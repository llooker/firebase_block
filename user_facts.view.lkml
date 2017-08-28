#### REPLACE TABLES IN FROM CLAUSE WITH TABLES FROM YOUR DATASET ####

view: user_facts {
 # if there is only one schema, unions can be removed from derived table
  derived_table: {
    sql: WITH app_events AS (SELECT
            app_events.*,
            'iOS' as platform,
            TIMESTAMP(PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'\d\d\d\d\d\d\d\d'))) AS _DATA_DATE
          FROM `bigquery-connectors.firebase.app_events_*` as app_events

        UNION ALL

        SELECT
            app_events.*,
            'Android' as platform,
            TIMESTAMP(PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'\d\d\d\d\d\d\d\d'))) AS _DATA_DATE
          FROM `bigquery-connectors.firebase_android.app_events_*` as app_events
        )
SELECT
  app_events__user_dim.user_id  AS app_events__user_dim_user_id,
  MIN(CAST(TIMESTAMP_SECONDS(cast((app_events__user_dim.first_open_timestamp_micros / 1000000) as int64)) AS DATE)) AS user_first_open_date,
  MIN(CAST(TIMESTAMP_SECONDS(cast((app_events__event_dim.timestamp_micros / 1000000) as int64)) AS DATE)) AS user_first_event_date
FROM app_events
LEFT JOIN UNNEST(app_events.event_dim) as app_events__event_dim
LEFT JOIN UNNEST([app_events.user_dim]) as app_events__user_dim

GROUP BY 1
;;
# sql_trigger_value: SELECT CURRENT_DATE ;;
  }


  dimension: user_id {
    hidden: yes
    type: string
    sql: ${TABLE}.app_events__user_dim_user_id ;;
  }

  dimension_group: user_first_open {
    label: "First Open"
    type: time
    timeframes: [date, week, month]
    sql: cast(${TABLE}.User_first_open_date as timestamp);;
  }

  dimension_group: user_first_event {
    label: "First Event"
    type: time
    timeframes: [date, week, month]
    sql: cast(${TABLE}.User_first_event_date as timestamp) ;;
  }

}
