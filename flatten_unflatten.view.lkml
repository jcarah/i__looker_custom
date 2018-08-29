
view: numbers {
  derived_table: {
    sql: select (t*10+u) digit from
        (select 0 t union select 1 union select 2 union select 3 union select 4 union
        select 5 union select 6 union select 7 union select 8 union select 9) A,
        (select 0 u union select 1 union select 2 union select 3 union select 4 union
        select 5 union select 6 union select 7 union select 8 union select 9) B
        order by digit; ;;
#   sql_trigger_value: select 1 ;;
  }
}
view: eav_data {
  derived_table: {
    sql: SELECT
          event.id as event_id,
          event_attribute.id as `event_attribute_id`,
          event.CREATED_AT,
          event.NAME AS `event_name`,
          event_attribute.NAME as event_attribute_name,
          event_attribute.VALUE as event_attribute_value,
          replace(replace(replace(event_attribute.value, '\"', ''), '[', ''),']','') as user_ids
        FROM event_attribute
        LEFT JOIN event ON event_attribute.EVENT_ID = event.ID
        WHERE event_attribute.name IN ('old_user_ids', 'new_user_ids') AND event.name in ('update_role_users')
        ;;
    indexes: ["event_id","created_at"]
  }
}


view: unflatten_eav {
  derived_table: {
    sql:
    SELECT
        event_id,
        event_name,
        event_attribute_name,
        event_attribute_id,
        CONCAT (user.first_name, ' ', user.last_name) as user_name,
        SUBSTRING_INDEX(SUBSTRING_INDEX(user_ids, ',', n.digit+1), ',', -1) as user_id,
        user_ids
      FROM
        ${eav_data.SQL_TABLE_NAME}
      JOIN
        ${numbers.SQL_TABLE_NAME} n
      ON LENGTH(REPLACE(user_ids, ',' , '')) <= LENGTH(user_ids)-n.digit
      JOIN user
      ON user.id =  SUBSTRING_INDEX(SUBSTRING_INDEX(user_ids, ',', n.digit+1), ',', -1) ;;
  }
}

view: flattened_old_user_names {
  derived_table: {
    sql:
    SELECT
      event_attribute_id,
      user_ids,
      group_concat(user_name) as user_names
    FROM
    ${unflatten_eav.SQL_TABLE_NAME}
    where event_attribute_name = 'old_user_ids'
    group by event_attribute_id, user_ids
    ;;
  }
  dimension: event_attribute_id {
    primary_key: yes
  }
  dimension: old_user_names {
    sql: ${TABLE}.user_names ;;
  }
}
# Ideally, we'd just have one DT for new and old user names. However, MySQL does not permit more joining a temporary table more than once.
view: flattened_new_user_names {
  derived_table: {
    sql:
    SELECT
      event_attribute_id,
      user_ids,
      group_concat(user_name) as user_names
    FROM
    ${unflatten_eav.SQL_TABLE_NAME}
    where event_attribute_name = 'new_user_ids'
    group by event_attribute_id, user_ids
    ;;
  }
  dimension: event_attribute_id {
    primary_key: yes
  }
  dimension: new_user_names {
    sql: ${TABLE}.user_names ;;
  }
}
