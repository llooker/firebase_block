# Based on this article: https://discourse.looker.com/t/analytic-block-daily-weekly-monthly-active-users/1499

view: dates {
  derived_table: {
    sql:
      SELECT DATE_ADD(DATE("2017-01-01"), INTERVAL (pos - 1) DAY) AS day
      FROM (
        SELECT ROW_NUMBER() OVER() AS pos
        FROM UNNEST( SPLIT(RPAD('',
        1 + DATE_DIFF(CURRENT_DATE(), DATE("2017-01-01"), DAY),
        '.'),''))) ;;
  }

  dimension: day {
    type: date
    sql: ${TABLE}.day ;;
    primary_key: yes
  }

}

view: use_rolling_30_day_window
{
  derived_table: {
    sql:
      SELECT
        app_instance_id,
        day,
        MIN(DATE_DIFF(day, time, DAY)) as days_since_last_action
      FROM
        ${dates.SQL_TABLE_NAME} as calendar_day
      JOIN (
        SELECT
          user_dim.app_info.app_instance_id,
          DATE(TIMESTAMP_MICROS(event.timestamp_micros), "America/Los_Angeles") AS time
        FROM
        -- use the existing app_events table that includes unions between schemas
          ${app_events.SQL_TABLE_NAME}
          LEFT JOIN UNNEST(app_events.event_dim) as event
        WHERE
          -- the following templated filter allows the user to select the event they want to filter on
          {% condition app_events__event_dim.name %} event.name {% endcondition %}

        GROUP BY
          1,
          2
        ORDER BY
          1,
          2) b
      ON
        (calendar_day.day >= b.time
          AND calendar_day.day < DATE_ADD(b.time, INTERVAL 30 DAY))
      GROUP BY
        1, 2
      ORDER BY
        1, 2 ;;
  }


  dimension: date {
    description: "Use this date when analyzing daily, weekly, monthly active users"
    type: date
    sql: cast(${TABLE}.day as timestamp) ;;
  }

  dimension: user_id {
    hidden: yes
    type: string
    sql: ${TABLE}.app_instance_id ;;
  }

  dimension: days_since_last_action {
    hidden: yes
    description: "How many days was it since the user last performed an action?"
    type: number
    sql: ${TABLE}.days_since_last_action ;;
    value_format_name: decimal_0
  }

  dimension: active_this_day {
    hidden: yes
    description: "Was the given user active today?"
    type: yesno
    sql: ${days_since_last_action} <  1 ;;
  }

  dimension: active_last_7_days {
    hidden: yes
    description: "Was the given user active in the last 7 days?"
    type: yesno
    sql: ${days_since_last_action} < 7 ;;
  }

  measure: user_count_active_30_days {
    label: "Monthly Active Users"
    description: "Number of distinct users active within 30 days from the given date"
    type: count_distinct
    sql: ${user_id} ;;
    drill_fields: [user_id]
  }

  measure: number_of_days_active {
    hidden: yes
    description: "How many days has a given user been active?"
    label: "# of Days Active"
    type: count_distinct
    sql: ${date} ;;
  }

  measure: user_count_active_this_day {
    label: "Daily Active Users"
    description: "Number of distinct users active on the given date"
    type: count_distinct
    sql: ${user_id} ;;
    drill_fields: [user_id]
    filters: {
      field: active_this_day
      value: "yes"
    }
  }

  measure: user_count_active_7_days {
    label: "Weekly Active Users"
    description: "Number of distinct users active within 7 days from the given date"
    type: count_distinct
    sql: ${user_id} ;;
    drill_fields: [user_id]
    filters: {
      field: active_last_7_days
      value: "yes"
    }
  }
}
