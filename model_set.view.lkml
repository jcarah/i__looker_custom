view: model_set {
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: built_in {
    type: yesno
    sql: ${TABLE}.BUILT_IN ;;
  }

  dimension: embed {
    type: yesno
    sql: ${TABLE}.EMBED ;;
  }

  dimension: models {
    sql: ${TABLE}.MODELS ;;
  }

  dimension: name {
    sql: ${TABLE}.NAME ;;
  }

  dimension: unlimited {
    type: yesno
    sql: ${TABLE}.UNLIMITED ;;
  }

  dimension: old_model_set_name {
    sql: ${TABLE}.NAME ;;
    label: "Old Model Set Name"
  }
  dimension: new_model_set_name {
    sql: ${TABLE}.NAME ;;
    label: "New Model Set Name"
  }

  measure: count {
    type: count
    drill_fields: [id, name, role.count]
  }
}
