- dashboard: firebase
  title: Firebase
  layout: newspaper
  elements:
  - name: Weekly Retention
    title: Weekly Retention
    model: firebase
    explore: app_events
    type: looker_line
    fields:
    - app_events__user_dim.number_of_users
    - app_events__event_dim.weeks_since_signup
    - app_events.platform
    pivots:
    - app_events.platform
    filters:
      app_events.date_range: 6 months
      app_events__event_dim.weeks_since_signup: "[1, 12]"
    sorts:
    - app_events__event_dim.weeks_since_signup
    - app_events.platform
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: returning
      label: "% Returning"
      expression: "${app_events__user_dim.number_of_users}/max(${app_events__user_dim.number_of_users})"
      value_format:
      value_format_name: percent_0
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: true
    point_style: none
    interpolation: linear
    hidden_fields:
    - app_events__user_dim.number_of_users
    colors:
    - "#64518A"
    - "#EA8A2F"
    - "#8D7FB9"
    - "#F2B431"
    - "#2DA5DE"
    - "#57BEBE"
    - "#7F7977"
    - "#B2A898"
    - "#494C52"
    series_colors: {}
    row: 9
    col: 0
    width: 12
    height: 5
  - name: Retention Cohorts
    title: Retention Cohorts
    model: firebase
    explore: app_events
    type: table
    fields:
    - app_events__user_dim.number_of_users
    - app_events__event_dim.weeks_since_signup
    - user_facts.user_first_event_week
    pivots:
    - app_events__event_dim.weeks_since_signup
    filters:
      app_events.date_range: 6 months
      app_events__event_dim.weeks_since_signup: NOT NULL
      user_facts.user_first_event_week: NOT NULL
    sorts:
    - app_events__event_dim.weeks_since_signup 0
    - user_facts.user_first_event_week
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: returning
      label: "% Returning"
      expression: "${app_events__user_dim.number_of_users}/max(pivot_row(${app_events__user_dim.number_of_users}))"
      value_format:
      value_format_name: percent_0
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: gray
    limit_displayed_rows: false
    enable_conditional_formatting: true
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: true
    point_style: none
    interpolation: linear
    hidden_fields:
    - app_events__user_dim.number_of_users
    colors:
    - "#64518A"
    - "#EA8A2F"
    - "#8D7FB9"
    - "#F2B431"
    - "#2DA5DE"
    - "#57BEBE"
    - "#7F7977"
    - "#B2A898"
    - "#494C52"
    series_colors: {}
    series_types: {}
    conditional_formatting:
    - type: low to high
      value:
      background_color:
      font_color:
      palette:
        name: Custom
        colors:
        - "#e5e1eb"
        - "#a196b8"
        - "#635189"
      bold: false
      italic: false
      strikethrough: false
    row: 4
    col: 0
    width: 12
    height: 5
  - name: Active Users
    title: Active Users
    model: use_rolling_30_day_window
    explore: window_30_view
    type: looker_line
    fields:
    - window_30_view.date
    - window_30_view.user_count_active_this_day
    - window_30_view.user_count_active_7_days
    - window_30_view.user_count_active_30_days
    filters:
      window_30_view.date: 30 days
    sorts:
    - window_30_view.date
    limit: 500
    column_limit: 50
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: true
    point_style: none
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    hidden_series: []
    row: 4
    col: 12
    width: 12
    height: 10
  - name: Devices
    title: Devices
    model: firebase
    explore: app_events
    type: looker_bar
    fields:
    - app_events__user_dim.number_of_users
    - app_events.platform
    pivots:
    - app_events.platform
    filters:
      app_events.date_range: 30 days
      app_events.platform: "-macOS"
    sorts:
    - app_events__user_dim.number_of_users desc 0
    - app_events.platform
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    stacking: percent
    show_value_labels: true
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    series_colors:
      iOS - app_events__user_dim.number_of_users: "#EA8A2F"
    y_axes:
    - label: ''
      maxValue:
      minValue:
      orientation: bottom
      showLabels: false
      showValues: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: Android
        name: Android
      - id: iOS
        name: iOS
    hidden_series: []
    row: 0
    col: 12
    width: 12
    height: 4
  - name: Users Last Week
    title: Users Last Week
    model: firebase
    explore: app_events
    type: single_value
    fields:
    - app_events__user_dim.number_of_users
    - app_events__event_dim.event_week
    filters:
      app_events.date_range: 30 days
      app_events__event_dim.event_week: 4 weeks ago for 4 weeks
    sorts:
    - app_events__event_dim.event_week desc
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: change
      label: change
      expression: 1-(offset(${app_events__user_dim.number_of_users},1)/${app_events__user_dim.number_of_users})
      value_format:
      value_format_name: percent_0
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    comparison_label: vs Previous Week
    single_value_title: Users Last Week
    row: 0
    col: 0
    width: 6
    height: 4
  - name: Devices Last Week
    title: Devices Last Week
    model: firebase
    explore: app_events
    type: single_value
    fields:
    - app_events__event_dim.event_week
    - app_events__user_dim__device_info.number_of_devices
    filters:
      app_events.date_range: 30 days
      app_events__event_dim.event_week: 4 weeks ago for 4 weeks
    sorts:
    - app_events__event_dim.event_week desc
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: change
      label: change
      expression: 1-(offset(${app_events__user_dim__device_info.number_of_devices},1)/${app_events__user_dim__device_info.number_of_devices})
      value_format:
      value_format_name: percent_0
      _kind_hint: measure
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    comparison_label: vs Previous Week
    single_value_title: Devices Last Week
    row: 0
    col: 6
    width: 6
    height: 4
