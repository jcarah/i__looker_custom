connection: "looker"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

persist_for: "6 hours"

explore: user_attribute {hidden:yes}

explore: history {
  join: look {
    foreign_key: look_id
  }

  join: query {
    foreign_key: query_id
  }

  join: user {
    foreign_key: user_id
  }

  join: embed_user {
    from: credentials_embed
    sql_on: ${user.id} = ${embed_user.user_id}
    relationship: one_to_one
  }

  join: space {
    foreign_key: look.space_id
  }

  join: role_user {
    sql_on: history.user_id = role_user.user_id ;;
    relationship: many_to_one
    fields: []
  }

  join: user_direct_role {
    relationship: one_to_many
    sql_on: ${user.id} = ${user_direct_role.user_id} ;;
    fields: []
  }

  join: group_user {
    relationship: one_to_many
    sql_on: ${user.id} = ${group_user.user_id} ;;
    fields: []
  }

  join: group {
    relationship: one_to_many
    sql_on: ${group.id} = ${group_user.group_id} ;;
  }

  join: role_group {
    relationship: one_to_many
    sql_on: ${role_group.group_id} = ${group_user.group_id} ;;
    fields: []
  }

  join: role {
    relationship: one_to_many
    sql_on: ${role.id} = ${user_direct_role.role_id} or ${role_group.role_id} = ${role.id} ;;
  }

  join: permission_set {
    foreign_key: role.permission_set_id
  }

  join: model_set {
    foreign_key: role.model_set_id
  }

  join: dashboard {
    relationship: many_to_one
    sql_on: ${history.dashboard_id} = ${dashboard.id} ;;
    fields: [history_detail*]
  }

  join: credentials_api {
    sql_on: ${user.id} = credentials_api.user_id ;;
    relationship: many_to_one
  }

  join: credentials_api3 {
    sql_on: ${user.id} = credentials_api3.user_id ;;
    relationship: many_to_one
  }

  join: sql_text {
    sql_on: ${history.cache_key} = ${sql_text.cache_key} ;;
    relationship: many_to_one
  }

  join: dashboard_filters {
    sql_on: ${history.dashboard_run_session_id} = ${dashboard_filters.run_session_id} ;;
    relationship: one_to_one
  }
}

explore: dashboard_run_history_facts {}

explore: dashboard_performance {
  from: dashboard_run_event_stats
  fields: [ALL_FIELDS*, -user.roles]
  view_label: "Dashboard Performance"

  always_filter: {
    filters: {
      field: dashboard_performance.raw_data_timeframe
      value: "2 hours"
    }
  }

  join: dashboard_run_history_facts {
    view_label: "Dashboard Performance"
    sql_on: ${dashboard_performance.dashboard_run_session} = ${dashboard_run_history_facts.dashboard_run_session_id} ;;
    relationship: one_to_one
  }

  join: dashboard_page_event_stats {
    view_label: "Dashboard Performance"
    sql_on: ${dashboard_performance.dashboard_page_session} = ${dashboard_page_event_stats.dashboard_page_session} ;;
    relationship: many_to_one
  }

  join: dashboard_filters {
    view_label: "Dashboard Performance"
    relationship: many_to_one
    sql_on: ${dashboard_filters.run_session_id} = ${dashboard_performance.dashboard_run_session} ;;
  }

  join: user {
    relationship: many_to_one
    sql_on: ${dashboard_performance.user_id} = ${user.id} ;;
    fields: [id, email, name, count]
  }
}

explore: look {
  fields: [ALL_FIELDS*, -user.roles]

  join: user {
    foreign_key: user_id
  }

  join: role_user {
    sql_on: role_user.user_id = ${user.id} ;;
    relationship: one_to_many
    fields: []
  }

  join: user_direct_role {
    relationship: one_to_many
    sql_on: ${user.id} = ${user_direct_role.user_id} ;;
    fields: []
  }

  join: group_user {
    relationship: one_to_many
    sql_on: ${user.id} = ${group_user.user_id} ;;
    fields: []
  }

  join: group {
    relationship: one_to_many
    sql_on: ${group.id} = ${group_user.group_id} ;;
  }

  join: role_group {
    relationship: one_to_many
    sql_on: ${role_group.group_id} = ${group_user.group_id} ;;
    fields: []
  }

  join: role {
    relationship: one_to_many
    sql_on: ${role.id} = ${user_direct_role.role_id} or ${role_group.role_id} = ${role.id} ;;
  }

  join: query {
    foreign_key: query_id
  }

  join: space {
    foreign_key: space_id
  }
}
