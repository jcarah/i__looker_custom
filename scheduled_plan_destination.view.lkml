view: scheduled_plan_destination {
  dimension: id {
    primary_key: yes
    type: number
  }
  dimension: address {}
  dimension: created_at {}
  dimension: format {}
  dimension: scheduled_plan_id {
    type: number
  }
  dimension: slug {}
  dimension: type {}
}

explore:scheduled_plan_destination  {}
