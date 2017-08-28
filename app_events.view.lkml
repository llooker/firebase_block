# this derived table unions app events from the ios, android and mac os schemas.
# it also leverages table_suffix to look across multiple date partitioned tables

# supporting documentation:
# derived tables: https://docs.looker.com/data-modeling/learning-lookml/derived-tables
# table suffix: https://discourse.looker.com/t/method-for-migrating-from-table-date-range-to-standard-sql-using-table-suffix/3732
# templated filters: https://docs.looker.com/data-modeling/learning-lookml/templated-filters
# google firebase documentation: https://cloud.google.com/solutions/mobile/mobile-firebase-analytics-big-query

#### REPLACE TABLES IN FROM CLAUSE WITH TABLES FROM YOUR DATASET ####
view: app_events {
# if there is only one schema, unions can be removed from derived table
  derived_table: {
    sql:
        -- all data from iOS dataset
        SELECT
            app_events.*,
            'iOS' as platform,
            TIMESTAMP(PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'\d\d\d\d\d\d\d\d'))) AS _DATA_DATE
         FROM `bigquery-connectors.firebase.app_events_*` as app_events
        -- add templated filter to reduce dataset to specified date partitions
        WHERE {% condition app_events.date_range%} TIMESTAMP(PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'\d\d\d\d\d\d\d\d'))) {% endcondition %}

         UNION ALL

        -- union all data from Android dataset
         SELECT
            app_events.*,
            'Android' as platform,
            TIMESTAMP(PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'\d\d\d\d\d\d\d\d'))) AS _DATA_DATE
         FROM `bigquery-connectors.firebase_android.app_events_*` as app_events
        -- add templated filter to reduce dataset to specified date partitions
         WHERE {% condition app_events.date_range%} TIMESTAMP(PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'\d\d\d\d\d\d\d\d'))) {% endcondition %}
        ;;
  }


  # enforce a date range filter for end users to avoid doing full scans of the database
  filter: date_range {
    description: "Select a date range for analysis"
    type: date
    sql: {% condition date_range%} _DATA_DATE {% endcondition %} ;;
  }

  dimension: platform {
    description: "iOS, macOS, Android, etc"
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension_group: partition {
    description: "Filter on Date Range to specify analysis timeframe"
    type: time
    timeframes: [date]
    sql: ${TABLE}._DATA_DATE ;;
  }

  dimension: event_dim {
    hidden: yes
    sql: ${TABLE}.event_dim ;;
  }

  dimension: user_dim {
    hidden: yes
    sql: ${TABLE}.user_dim ;;
  }

}

view: app_events__user_dim__device_info {
  dimension: device_category {
    group_label: "Device Info"
    type: string
    sql: ${TABLE}.device_category ;;
  }

  dimension: device_id {
    group_label: "Device Info"
    type: string
    sql: ${TABLE}.device_id ;;
  }

  dimension: device_model {
    group_label: "Device Info"
    type: string
    sql: ${TABLE}.device_model ;;
  }

  dimension: device_time_zone_offset_seconds {
    group_label: "Device Info"
    type: number
    sql: ${TABLE}.device_time_zone_offset_seconds ;;
  }

  dimension: limited_ad_tracking {
    group_label: "Device Info"
    type: yesno
    sql: ${TABLE}.limited_ad_tracking ;;
  }

  dimension: mobile_brand_name {
    group_label: "Device Info"
    type: string
    sql: ${TABLE}.mobile_brand_name ;;
  }

  dimension: mobile_marketing_name {
    group_label: "Device Info"
    type: string
    sql: ${TABLE}.mobile_marketing_name ;;
  }

  dimension: mobile_model_name {
    group_label: "Device Info"
    type: string
    sql: ${TABLE}.mobile_model_name ;;
  }

  dimension: platform_version {
    group_label: "Device Info"
    type: string
    sql: ${TABLE}.platform_version ;;
  }

  dimension: resettable_device_id {
    group_label: "Device Info"
    type: string
    sql: ${TABLE}.resettable_device_id ;;
  }

  dimension: user_default_language {
    group_label: "Device Info"
    type: string
    sql: ${TABLE}.user_default_language ;;
  }

    measure: number_of_devices {
    type: count_distinct
    sql: ${device_id} ;;
    drill_fields: [device_id, device_category, device_model]
  }

}

view: app_events__user_dim {
  dimension: app_info {
    hidden: yes
    sql: ${TABLE}.app_info ;;
  }

  dimension: bundle_info {
    hidden: yes
    sql: ${TABLE}.bundle_info ;;
  }

  dimension: device_info {
    hidden: yes
    sql: ${TABLE}.device_info ;;
  }

  dimension: first_open_timestamp_micros {
    type: number
    hidden: yes
    sql: ${TABLE}.first_open_timestamp_micros ;;
  }

  dimension_group: first_open {
    hidden: yes
    type: time
    datatype: epoch
    timeframes: [raw, time, date, week, month]
    sql: cast((${TABLE}.first_open_timestamp_micros / 1000000) as int64);; #convert from microseconds to timestamp
  }

  dimension: geo_info {
    hidden: yes
    sql: ${TABLE}.geo_info ;;
  }

  dimension: ltv_info {
    hidden: yes
    sql: ${TABLE}.ltv_info ;;
  }

  dimension: traffic_source {
    hidden: yes
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: user_properties {
    hidden: yes
    sql: ${TABLE}.user_properties ;;
  }

  measure: number_of_users {
    type: count_distinct
    sql: ${user_id} ;;
    drill_fields: [user_id, app_events.platform]
  }

}

view: app_events__user_dim__user_properties__value {
  dimension: index {
    type: number
    sql: ${TABLE}.index ;;
  }

  dimension: set_timestamp_usec {
    type: number
    sql: ${TABLE}.set_timestamp_usec ;;
  }

  dimension: value {
    hidden: yes
    sql: ${TABLE}.value ;;
  }
}

view: app_events__user_dim__user_properties__value__value {
  dimension: double_value {
    type: number
    sql: ${TABLE}.double_value ;;
  }

  dimension: float_value {
    type: number
    sql: ${TABLE}.float_value ;;
  }

  dimension: int_value {
    type: number
    sql: ${TABLE}.int_value ;;
  }

  dimension: string_value {
    type: string
    sql: ${TABLE}.string_value ;;
  }

}

view: app_events__user_dim__user_properties {
  dimension: key {
    type: string
    sql: ${TABLE}.key ;;
  }

  dimension: value {
    hidden: yes
    sql: ${TABLE}.value ;;
  }
}

view: app_events__user_dim__ltv_info {
  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: revenue {
    type: number
    sql: ${TABLE}.revenue ;;
  }
}

view: app_events__user_dim__geo_info {
  dimension: city {
    group_label: "Geo Info"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: continent {
    group_label: "Geo Info"
    type: string
    sql: ${TABLE}.continent ;;
  }

  dimension: country {
    group_label: "Geo Info"
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: region {
    group_label: "Geo Info"
    type: string
    sql: ${TABLE}.region ;;
  }
}

view: app_events__user_dim__app_info {
  dimension: app_id {
    group_label: "App Info"
    type: string
    sql: ${TABLE}.app_id ;;
  }

  dimension: app_instance_id {
    group_label: "App Info"
    type: string
    sql: ${TABLE}.app_instance_id ;;
  }

  dimension: app_platform {
    group_label: "App Info"
    type: string
    sql: ${TABLE}.app_platform ;;
  }

  dimension: app_store {
    group_label: "App Info"
    type: string
    sql: ${TABLE}.app_store ;;
  }

  dimension: app_version {
    group_label: "App Info"
    type: string
    sql: ${TABLE}.app_version ;;
  }
}

view: app_events__user_dim__bundle_info {
  dimension: bundle_sequence_id {
    group_label: "Bundle Info"
    type: number
    sql: ${TABLE}.bundle_sequence_id ;;
  }

  dimension: server_timestamp_offset_micros {
    group_label: "Bundle Info"
    type: number
    sql: ${TABLE}.server_timestamp_offset_micros ;;
  }
}

view: app_events__user_dim__traffic_source {
  dimension: user_acquired_campaign {
    group_label: "Traffic Source"
    type: string
    sql: ${TABLE}.user_acquired_campaign ;;
  }

  dimension: user_acquired_medium {
    group_label: "Traffic Source"
    type: string
    sql: ${TABLE}.user_acquired_medium ;;
  }

  dimension: user_acquired_source {
    group_label: "Traffic Source"
    type: string
    sql: ${TABLE}.user_acquired_source ;;
  }
}

view: app_events__event_dim {
  dimension: date {
    type: string
    hidden: yes
    sql: ${TABLE}.date ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: params {
    hidden: yes
    sql: ${TABLE}.params ;;
  }

  dimension: previous_timestamp_micros {
    type: number
    hidden: yes
    sql: ${TABLE}.previous_timestamp_micros ;;
  }

  dimension: timestamp_micros {
    type: number
    hidden: yes
    sql: ${TABLE}.timestamp_micros ;;
  }

  dimension_group: event {
    type: time
    datatype: epoch
    timeframes: [raw, time, date, week, month]
    sql: cast((${TABLE}.timestamp_micros / 1000000) as int64);; #convert from microseconds to timestamp
  }

  dimension: months_since_signup {
    description: "Number of months the event occured since the user first opened the app"
    type: number
    sql: DATE_DIFF(${event_date}, ${user_facts.user_first_event_date}, MONTH) ;;
  }

  dimension: days_since_signup {
    description: "Number of days the event occured since the user first opened the app"
    type: number
    sql: DATE_DIFF(${event_date}, ${user_facts.user_first_event_date}, DAY) ;;
  }

  dimension: weeks_since_signup {
    description: "Number of weeks the event occured since the user first opened the app"
    type: number
    sql: DATE_DIFF(${event_date}, ${user_facts.user_first_event_date}, WEEK) ;;
  }

  dimension: value_in_usd {
    type: number
    hidden: yes
    value_format_name: usd
    sql: ${TABLE}.value_in_usd ;;
  }

  dimension: primary_key {
    type: string
    primary_key: yes
    hidden: yes
    sql: concat(${name},'-',cast(${timestamp_micros} as string)) ;;
  }

  measure: count {
    label: "Number of Events"
    type: count
    drill_fields: [app_events.partition_date, count]
  }
}

view: app_events__event_dim__params__value {
  dimension: double_value {
    type: number
    sql: ${TABLE}.double_value ;;
  }

  dimension: float_value {
    type: number
    sql: ${TABLE}.float_value ;;
  }

  dimension: int_value {
    type: number
    sql: ${TABLE}.int_value ;;
  }

  dimension: string_value {
    type: string
    sql: ${TABLE}.string_value ;;
  }
}

view: app_events__event_dim__params {
  dimension: key {
    type: string
    sql: ${TABLE}.key ;;
  }

  dimension: value {
    hidden: yes
    sql: ${TABLE}.value ;;
  }
}
