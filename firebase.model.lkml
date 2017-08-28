### Replace connection parameter with your database connection name

connection: "firebase_blocks"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project


explore: app_events {
  view_label: "Events"

  # enforce a date range filter so users must select a partition range
  always_filter: {
    filters: {
      field: date_range
      value: "1 days"
    }
  }

  join: app_events__event_dim {
    view_label: "Events"
    sql: LEFT JOIN UNNEST(${app_events.event_dim}) as app_events__event_dim ;;
    relationship: one_to_many
  }

  join: app_events__event_dim__params {
    fields: [] # display only selected fields on the field picker. display nothing if array is empty
    view_label: "App Events: Event Dim Params"
    sql: LEFT JOIN UNNEST(${app_events__event_dim.params}) as app_events__event_dim__params ;;
    relationship: one_to_many
  }

  join: app_events__event_dim__params__value {
    fields: [] # display only selected fields on the field picker. display nothing if array is empty
    view_label: "App Events: Event Dim Params Value"
    sql: LEFT JOIN UNNEST([${app_events__event_dim__params.value}]) as app_events__event_dim__params__value ;;
    relationship: one_to_many
  }

  join: app_events__user_dim {
    view_label: "Users"
    sql: LEFT JOIN UNNEST([${app_events.user_dim}]) as app_events__user_dim ;;
    relationship: one_to_one
  }

  join: user_facts {
    view_label: "Users"
    type: left_outer
    sql_on: ${user_facts.user_id} = ${app_events__user_dim.user_id} ;;
    relationship: many_to_one
  }

  join: app_events__user_dim__user_properties {
    fields: [] # display only selected fields on the field picker. display nothing if array is empty
    view_label: "Users"
    sql: LEFT JOIN UNNEST(${app_events__user_dim.user_properties}) as app_events__user_dim__user_properties ;;
    relationship: one_to_many
  }

  join: app_events__user_dim__user_properties__value {
    fields: [] # display only selected fields on the field picker. display nothing if array is empty
    view_label: "Users"
    sql: LEFT JOIN UNNEST([${app_events__user_dim__user_properties.value}]) as app_events__user_dim__user_properties__value ;;
    relationship: one_to_many
  }

  join: app_events__user_dim__user_properties__value__value {
    # fields: [app_events__user_dim__user_properties__value__value.device_id, app_events__user_dim__user_properties__value__value.number_of_devices] # display only selected fields on the field picker. display nothing if array is empty
    fields: []
    view_label: "Users"
    sql: LEFT JOIN UNNEST([${app_events__user_dim__user_properties__value.value}]) as app_events__user_dim__user_properties__value__value ;;
    relationship: one_to_many
  }

  join: app_events__user_dim__device_info {
    view_label: "Users"
    sql: LEFT JOIN UNNEST([${app_events__user_dim.device_info}]) as app_events__user_dim__device_info ;;
    relationship: one_to_many
  }

  join: app_events__user_dim__geo_info {
    view_label: "Users"
    sql: LEFT JOIN UNNEST([${app_events__user_dim.geo_info}]) as app_events__user_dim__geo_info ;;
    relationship: one_to_many
  }

  join: app_events__user_dim__ltv_info {
    fields: [] # display only selected fields on the field picker. display nothing if array is empty
    view_label: "App Events: User Dim LTV Info"
    sql: LEFT JOIN UNNEST([${app_events__user_dim.ltv_info}]) as app_events__user_dim__ltv_info ;;
    relationship: one_to_many
  }

  join: app_events__user_dim__app_info {
    view_label: "Users"
    sql: LEFT JOIN UNNEST([${app_events__user_dim.app_info}]) as app_events__user_dim__app_info ;;
    relationship: one_to_many
  }

  join: app_events__user_dim__bundle_info {
    view_label: "Users"
    sql: LEFT JOIN UNNEST([${app_events__user_dim.bundle_info}]) as app_events__user_dim__bundle_info ;;
    relationship: one_to_many
  }

  join: app_events__user_dim__traffic_source {
    view_label: "Users"
    sql: LEFT JOIN UNNEST([${app_events__user_dim.traffic_source}]) as app_events__user_dim__traffic_source ;;
    relationship: one_to_many
  }

  # optional join - only if you want to look at daily, weekly, monthly active users
  join: use_rolling_30_day_window {
    view_label: "Daily, Weekly, Monthly Active Users"
    type: left_outer
    relationship: one_to_many
    sql_on: ${app_events__user_dim__app_info.app_instance_id} = ${use_rolling_30_day_window.user_id} ;;
  }

}
