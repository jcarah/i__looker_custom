connection: "looker"

# include all the views
include: "*.view"

explore: export_queries_events {
  from: event
  view_label: "Export Queries Events"
  join: export_format {
    from: event_attribute
    sql_on: ${export_queries_events.id} = ${export_format.event_id} ;;
    sql_where:${export_queries_events.name} = 'export_query' AND ${export_format.name} = 'export_format'  ;;
    fields: [export_format.value]
    view_label: "Export Queries Events Attributes"
    relationship: one_to_many
  }
  join: query_params {
    from: event_attribute
    sql_on: ${export_queries_events.id} = ${query_params.event_id} ;;
    relationship: one_to_many
    sql_where:${export_queries_events.name} = 'export_query' AND ${query_params.name} = 'query_params'  ;;
    fields: [query_params.value]
    view_label: "Export Queries Event Attributes"
  }
  join: source {
    from: event_attribute
    sql_on: ${export_queries_events.id} = ${source.event_id} ;;
    relationship: one_to_many
    sql_where:${export_queries_events.name} = 'export_query' AND ${source.name} = 'source'  ;;
    fields: [source.value]
    view_label: "Export Queries Event Attributes"
  }
  join: history_id {
    from: event_attribute
    sql_on: ${export_queries_events.id} = ${history_id.event_id} ;;
    relationship: one_to_many
    sql_where:${export_queries_events.name} = 'export_query' AND ${history_id.name} = 'history_id'  ;;
    fields: [history_id.value]
    view_label: "Export Queries Event Attributes"
  }
  join: history {
    sql_on: ${history_id.value} = ${history.id} ;;
    relationship: many_to_one
    fields: ["history.link"]
    view_label: "Export Queries Event Attributes"
  }
  join: user {
    sql_on: ${export_queries_events.user_id} = ${user.id} ;;
    relationship: many_to_one
    fields: ["user.name"]
    view_label: "Export Queries Event Attributes"
  }
}

explore: scheduler_delivery_events  {
  from:  event
  view_label: "Scheduler Delivery Events"
  join: scheduled_plan_id {
    from: event_attribute
    sql_on: ${scheduler_delivery_events.id} = ${scheduled_plan_id.event_id} ;;
    relationship: one_to_many
    sql_where: ${scheduler_delivery_events.name} = 'scheduled_plan_id'  AND ${scheduled_plan_id.id};;
    fields: ["scheduled_plan_id.value", "scheduled_plan_id.schedule_plan_history_link"]
    view_label: "Scheduler Delivery Event Attributes"
  }
}

explore: update_role_user_events {
  from: event
  view_label: "Update Role Users"
  join: update_role_user_old_user_ids {
    from: event_attribute
    sql_on: ${update_role_user_events.id} = ${update_role_user_old_user_ids.event_id} ;;
    relationship: one_to_many
    sql_where:${update_role_user_events.name} = 'update_role_users' AND ${update_role_user_old_user_ids.name} = 'old_user_ids' ;;
    fields: [update_role_user_old_user_ids.value]
    view_label: "Update Role Users"
  }
  join: old_user_names {
    from: flattened_old_user_names
    sql_on: ${update_role_user_old_user_ids.id} = ${old_user_names.event_attribute_id} ;;
    fields: [old_user_names.old_user_names]
    view_label: "Update Role Users"
    relationship: one_to_one
  }
  join: update_role_user_new_user_ids {
    from: event_attribute
    sql_on: ${update_role_user_events.id} = ${update_role_user_new_user_ids.event_id} ;;
    relationship: one_to_many
    sql_where:${update_role_user_events.name} = 'update_role_users' AND ${update_role_user_new_user_ids.name} = 'new_user_ids' ;;
    fields: [update_role_user_new_user_ids.value]
    view_label: "Update Role Users"
  }
  join: new_user_names {
    from: flattened_new_user_names
    sql_on: ${update_role_user_new_user_ids.id} = ${new_user_names.event_attribute_id} ;;
    view_label: "Update Role Users"
    relationship: one_to_one
  }
}


#
#   join: embed_user {
#     from: credentials_embed
#     sql_on: ${user.id} = ${embed_user.user_id}
#     relationship: one_to_one
#   }

#   join: space {
#     foreign_key: look.space_id
#   }
#
#   join: role_user {
#     sql_on: history.user_id = role_user.user_id ;;
#     relationship: many_to_one
#     fields: []
#   }
#
#   join: user_direct_role {
#     relationship: one_to_many
#     sql_on: ${user.id} = ${user_direct_role.user_id} ;;
#     fields: []
#   }
#
#   join: group_user {
#     relationship: one_to_many
#     sql_on: ${user.id} = ${group_user.user_id} ;;
#     fields: []
#   }

#   join: group {
#     relationship: one_to_many
#     sql_on: ${group.id} = ${group_user.group_id} ;;
#   }

#   join: role_group {
#     relationship: one_to_many
#     sql_on: ${role_group.group_id} = ${group_user.group_id} ;;
#     fields: []
#   }
#
#   join: role {
#     relationship: one_to_many
#     sql_on: ${role.id} = ${user_direct_role.role_id} or ${role_group.role_id} = ${role.id} ;;
#   }

#   join: permission_set {
#     foreign_key: role.permission_set_id
#   }

#   join: model_set {
#     foreign_key: role.model_set_id
#   }
#
#   join: dashboard {
#     relationship: many_to_one
#     sql_on: ${history.dashboard_id} = ${dashboard.id} ;;
#     fields: [history_detail*]
#   }
#
#   join: credentials_api {
#     sql_on: ${user.id} = credentials_api.user_id ;;
#     relationship: many_to_one
#   }
#
#   join: credentials_api3 {
#     sql_on: ${user.id} = credentials_api3.user_id ;;
#     relationship: many_to_one
#   }
#
#   join: sql_text {
#     sql_on: ${history.cache_key} = ${sql_text.cache_key} ;;
#     relationship: many_to_one
#   }
#
#   join: dashboard_filters {
#     sql_on: ${history.dashboard_run_session_id} = ${dashboard_filters.run_session_id} ;;
#     relationship: one_to_one
#   }
# }
#
# explore: dashboard_run_history_facts {}
#
# explore: dashboard_performance {
#   from: dashboard_run_event_stats
#   fields: [ALL_FIELDS*, -user.roles]
#   view_label: "Dashboard Performance"
#
#   always_filter: {
#     filters: {
#       field: dashboard_performance.raw_data_timeframe
#       value: "2 hours"
#     }
#   }
#
#   join: dashboard_run_history_facts {
#     view_label: "Dashboard Performance"
#     sql_on: ${dashboard_performance.dashboard_run_session} = ${dashboard_run_history_facts.dashboard_run_session_id} ;;
#     relationship: one_to_one
#   }
#
#   join: dashboard_page_event_stats {
#     view_label: "Dashboard Performance"
#     sql_on: ${dashboard_performance.dashboard_page_session} = ${dashboard_page_event_stats.dashboard_page_session} ;;
#     relationship: many_to_one
#   }
#
#   join: dashboard_filters {
#     view_label: "Dashboard Performance"
#     relationship: many_to_one
#     sql_on: ${dashboard_filters.run_session_id} = ${dashboard_performance.dashboard_run_session} ;;
#   }
#
#   join: user {
#     relationship: many_to_one
#     sql_on: ${dashboard_performance.user_id} = ${user.id} ;;
#     fields: [id, email, name, count]
#   }
# }
#
# explore: look {
#   fields: [ALL_FIELDS*, -user.roles]
#
#   join: user {
#     foreign_key: user_id
#   }
#
#   join: role_user {
#     sql_on: role_user.user_id = ${user.id} ;;
#     relationship: one_to_many
#     fields: []
#   }
#
#   join: user_direct_role {
#     relationship: one_to_many
#     sql_on: ${user.id} = ${user_direct_role.user_id} ;;
#     fields: []
#   }
#
#   join: group_user {
#     relationship: one_to_many
#     sql_on: ${user.id} = ${group_user.user_id} ;;
#     fields: []
#   }
#
#   join: group {
#     relationship: one_to_many
#     sql_on: ${group.id} = ${group_user.group_id} ;;
#   }
#
#   join: role_group {
#     relationship: one_to_many
#     sql_on: ${role_group.group_id} = ${group_user.group_id} ;;
#     fields: []
#   }
#
#   join: role {
#     relationship: one_to_many
#     sql_on: ${role.id} = ${user_direct_role.role_id} or ${role_group.role_id} = ${role.id} ;;
#   }
#
#   join: query {
#     foreign_key: query_id
#   }
#
#   join: space {
#     foreign_key: space_id
#   }
