view: permission_set {
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: edit_link {
    type: string
    sql: ${id} ;;
    html: <a href='/admin/permission_sets/{{value}}/edit'>Edit</a>;;
  }

  dimension: built_in {
    type: yesno
    sql: ${TABLE}.BUILT_IN ;;
  }

  dimension: embed {
    type: yesno
    sql: ${TABLE}.EMBED ;;
  }

  dimension: name {
    sql: ${TABLE}.NAME ;;
    label: "Permission Set Name"
  }

  dimension: permissions {
    sql: ${TABLE}.PERMISSIONS ;;
  }

  dimension: unlimited {
    type: yesno
    sql: ${TABLE}.UNLIMITED ;;
  }

  measure: permissions_list {
    type: string
    sql: group_concat(${name}) ;;
  }

  dimension: old_permission_set_name {
    sql: ${TABLE}.NAME ;;
    label: "Old Permission Set Name"
  }
  dimension: new_permission_set_name {
    sql: ${TABLE}.NAME ;;
    label: "New Permission Set Name"
  }


  measure: count {
    type: count
    drill_fields: [id, name, role.count]
  }
}
