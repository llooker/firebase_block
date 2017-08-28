# firebase_block

LookML files for a Firebase block compatible with [Google BigQuery](https://cloud.google.com/solutions/mobile/mobile-firebase-analytics-big-query).

To use this block, you will need to:
1. Replace the connection name in the model file
2. Replace the schema and tables in the `from` clause of the app_events derived table with your tables (add additional unions if you have more than 2 devices (iOS, android, etc))
3. Replace the schema and tables in the `from` clause of the user_facts derived table with your tables (add additional unions if you have more than 2 devices (iOS, android, etc))
4. The use_rolling_30_day_window.view.lkml is an optional view file to analyze daily, weekly, and monthly active users based on [this block](https://discourse.looker.com/t/analytic-block-daily-weekly-monthly-active-users/1499). If not using, remove this join from the model file
