view: agg_awareness {

    derived_table: {

      explore_source: history {
        column: approximate_usage_in_minutes {}
        column: average_runtime {}
        column: cache_ratio {}
        column: first_query_date {}
        column: max_runtime {}
        column: min_runtime {}
        column: created_date {}
        column: created_month {}
        column: created_week {}
      }
    }
    dimension: approximate_usage_in_minutes {
      label: "History Approximate Web Usage in Minutes"
      type: number
    }
    dimension: average_runtime {
      value_format: "#,##0.00"
      type: number
    }
    dimension: cache_ratio {
      value_format: "0\%"
      type: number
    }
    dimension: first_query_date {
      type: number
    }
    dimension: max_runtime {
      type: number
    }
    dimension: min_runtime {
      type: number
    }
    dimension: created_date {
      type: date
    }
    dimension: created_month {
      type: date_month
    }
    dimension: created_week {
      type: date_week
    }
  }
