view: history {
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;

    link: {
      label: "Show in Admin"
      url: "/admin/queries/{{value}}"
    }
  }
  dimension: link {
    # Plain text version of link so it can be referenced in an export
    sql: ${history.id} ;;
    html: https://wework.looker.com/admin/queries/{{value}} ;;
  }

  #  - dimension: runtime
  #    label: Runtime in Seconds
  #    type: number
  #    sql: ${TABLE}.RUNTIME
  #    value_format: 0.###

  dimension: runtime {
    type: number
    sql: CASE
        WHEN result_source = 'query' THEN ${TABLE}.runtime
        ELSE ${TABLE}.completed_at - ${TABLE}.created_at + 0.5
      END
       ;;
  }

  dimension: runtime_tiers {
    label: "Runtime Tiers in Seconds"
    type: tier
    tiers: [
      1,
      5,
      10,
      30,
      120,
      300
    ]
    sql: ${runtime} ;;
    style: integer
  }

  dimension: runtime_tiers_long {
    label: "Runtime Tiers in Seconds Long"
    type: tier
    tiers: [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      15,
      25,
      35,
      50,
      100,
      300,
      1000
    ]
    sql: ${runtime} ;;
    style: interval
  }

  dimension: default_source {
    case: {
      when: {
        sql: ${TABLE}.source = 'api3' ;;
        label: "API 3.0"
      }

      when: {
        sql: ${TABLE}.source = 'dashboard' or ${TABLE}.source = 'run_async' ;;
        label: "Dashboard"
      }

      when: {
        sql: ${TABLE}.source = 'dashboard_prefetch' ;;
        label: "Dashboard Prefetch"
      }

      when: {
        sql: ${TABLE}.source = 'explore' ;;
        label: "Explore"
      }

      when: {
        sql: ${TABLE}.source = 'private_embed' or ${TABLE}.source = 'private_url' ;;
        label: "Private Embed"
      }

      when: {
        sql: ${TABLE}.source = 'public_embed' or ${TABLE}.source = 'public_url' ;;
        label: "Public Embed"
      }

      when: {
        sql: ${TABLE}.source = 'scheduled_task' ;;
        label: "Scheduled Task"
      }

      when: {
        sql: ${TABLE}.source like 'look%' ;;
        label: "Saved Look"
      }

      when: {
        sql: ${TABLE}.source = 'sqlrunner' ;;
        label: "SQL Runner"
      }

      when: {
        sql: ${TABLE}.source = 'suggest' ;;
        label: "Suggest Filter"
      }

      when: {
        sql: ${TABLE}.source = 'query' ;;
        label: "Query"
      }

      when: {
        sql: ${TABLE}.source like 'render_manager%' ;;
        label: "Renderer"
      }

      when: {
        sql: true ;;
        label: "Other"
      }
    }

    alpha_sort: yes
  }

  dimension: raw_source {
    sql: ${TABLE}.source ;;
    hidden: yes
  }

  dimension: source {
    sql: case when ${default_source} = 'Other' then ${raw_source}
      else ${default_source} end;;
  }

  dimension: node_id {
    type: number
    sql: ${TABLE}.node_id ;;
  }

  dimension: status {
    sql: ${TABLE}.status ;;
  }

  dimension: slug {
    sql: ${TABLE}.slug ;;
  }

  dimension: cache_key {
    sql: ${TABLE}.cache_key ;;
  }

  dimension: is_cached {
    type: yesno
    sql: ${cache_key} IS NOT NULL ;;
  }

  dimension: result_source {
    sql: ${TABLE}.result_source ;;
  }

  dimension: message {
    sql: ${TABLE}.message ;;
  }

  dimension: connection_name {
    sql: ${TABLE}.connection_name ;;
  }

  dimension: connection_id {
    sql: ${TABLE}.connection_id ;;
  }

  dimension: dialect {
    sql: ${TABLE}.dialect ;;
  }

  dimension: most_recent_length {
    label: "Most Recent Run Length in Seconds"
    type: number
    sql: (SELECT max_created.runtime
        FROM (SELECT query_id, runtime
              FROM HISTORY h,
                  (SELECT query_id
                  ,MAX(created_at) as max_created
                  from history
                  group by query_id) as hi
              where h.query_id = hi.query_id and h.created_at = hi.max_created
              and runtime is not null) as max_created
        WHERE ${TABLE}.query_id = max_created.query_id)
       ;;
    value_format: "0.###"
  }

  dimension_group: most_recent_run_at {
    label: "Most Recent Query Run at"
    type: time
    sql: (SELECT max_created
      FROM
        (SELECT query_id
        ,MAX(created_at) as max_created
        from history
        group by query_id) as hi
      where ${TABLE}.query_id = hi.query_id)
       ;;
  }

  measure: query_run_count {
    description: "This field is best used in conjunction with a filter or pivot on history source."
    label: "Query Run Count"
    type: count
    drill_fields: [drill_for_dash*]
  }

  measure: query_run_count_no_cache {
    label: "Query Run Count Without Cache"
    type: sum
    drill_fields: [drill_for_dash*]
    sql: CASE WHEN ${result_source} = 'query' THEN 1 ELSE 0 END
      ;;
  }

  measure: query_run_count_cache {
    label: "Query Run Count From Cache"
    type: sum
    drill_fields: [drill_for_dash*]
    sql: CASE WHEN ${result_source} = 'cache' THEN 1 ELSE 0 END
      ;;
  }

  measure: cache_ratio {
    type: number
    value_format: "0\%"
    sql: 100.0 * ${query_run_count_cache} / ${query_run_count} ;;
  }

  dimension_group: created {
    type: time
    sql: ${TABLE}.CREATED_AT ;;
  }

  dimension_group: minute_of_day {
    type: time
    timeframes: [time]
    sql: TIMEDIFF(CAST(${created_minute} AS TIME), CAST(${created_date} AS TIME)) ;;
  }

  dimension: look_id {
    type: number
    hidden: yes
    sql: ${TABLE}.LOOK_ID ;;
  }

  dimension: query_id {
    type: number
    hidden: yes
    sql: ${TABLE}.QUERY_ID ;;
  }

  dimension: title {}

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.USER_ID ;;
  }

  dimension: dashboard_id {
    description: "This is a string field so that LookML dashboard id's will appear"
    type: string
    sql: ${TABLE}.dashboard_id ;;

    link: {
      label: "View Dashboard"
      url: "/dashboards/{{ value }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }

    link: {
      label: "Go to Dashboard Performance Lookup"
      url: "/dashboards/looker_internal::4__dashboard_perf_lookup?Dashboard={{ value }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }
  }


  dimension: dashboard_run_session_id {
    alias: [dashboard_session]
    sql: ${TABLE}.dashboard_session ;;
  }

  measure: first_query_date {
    type: date
    sql: MIN(${TABLE}.CREATED_AT) ;;
  }

  measure: most_recent_query_date {
    type: date
    sql: MAX(${TABLE}.CREATED_AT) ;;
  }

  measure: total_runtime {
    type: sum
    sql: ${runtime} ;;
  }

  measure: max_runtime {
    type: max
    sql: ${runtime} ;;
  }

  measure: min_runtime {
    type: min
    sql: ${runtime} ;;
  }

  measure: average_runtime {
    type: average
    sql: NULLIF(${runtime},0) ;;
    value_format_name: decimal_2
  }

  measure: approximate_usage_in_minutes {
    label: "Approximate Web Usage in Minutes"
    type: number
    sql: COUNT(DISTINCT
        CASE WHEN ${TABLE}.source <> 'scheduled_task' THEN
          CONCAT(
           CAST(${TABLE}.user_id as CHAR(30)),
           FLOOR(UNIX_TIMESTAMP(${TABLE}.created_at)/(60*5))
        )
        ELSE NULL
        END
      )*5
       ;;
  }

  # ----- Detail ------
  set: drill_for_dash {
    fields: [
      history.id,
      history.created_time,
      user.name,
      query.model,
      query.view,
      history.source,
      query.formatted_fields,
      query.formatted_pivots,
      query.formatted_filters,
      query.limit,
      history.runtime
    ]
  }

  set: user_dash_drill_fields {
    fields: [history.created_time, dashboard.title, user.name, history.runtime]
  }

  set: drill_fields {
    fields: [
      history.id,
      history.created_time,

      #     - user_email.email
      user.email,
      query.model,
      query.view,
      query.formatted_fields,
      query.formatted_filters,
      query.limit,
      history.runtime
    ]
  }
}
