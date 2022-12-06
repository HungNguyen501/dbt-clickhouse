dbt --log-format json debug --profiles-dir ./ --target dev
dbt debug --profiles-dir ./ --target dev

dbt --log-format json test --profiles-dir ./ --target dev
dbt test --profiles-dir ./ --target dev
run_time_at=$(date +"%Y-%m-%d_%H:%M:%S.%6N") && dbt --log-format json test --profiles-dir ./ --target dev --vars "{'date_run': 2022-11-17, 'run_time_at': ${run_time_at}}" --select tag:daily ; python3 alert_bot/main.py -r ${run_time_at};

dbt build --profiles-dir ./ --target dev

# Test macro
dbt run-operation --profiles-dir ./ --target dev run_unit_tests
dbt run-operation --profiles-dir ./ --target dev test

# Run dbt
dbt run --profiles-dir ./ --target dev
dbt run --profiles-dir ./ --target dev --vars '{"date_run": "2022-11-17"}'
dbt run --profiles-dir ./ --target dev --vars '{"date_run": "2022-11-17"}' --select website_analysis
dbt run --profiles-dir ./ --target dev --vars '{"date_run": "2022-11-17"}' --select tag:website_analysis_tool
dbt --log-format json run --profiles-dir ./ --target dev --vars '{"date_run": "2022-11-17"}' --select tag:website_analysis_tool
dbt --debug --log-format json run --profiles-dir ./ --target dev --vars '{"date_run": "2022-11-17"}' --select tag:website_analysis_tool

run_time_at=$(date +"%Y-%m-%d_%H:%M:%S.%6N") && dbt --log-format json run --profiles-dir ./ --target dev --vars "{'date_run': 2022-11-17, 'run_time_at': ${run_time_at}}" --select tag:daily ; python3 alert_bot/main.py -r ${run_time_at};

# to make dbt exit immediately if a single resource fails to build. If other models are in-progress 
# when the first model fails, then dbt will terminate the connections for these still-running models.
dbt --fail-fast run --profiles-dir ./ --target dev --vars '{"date_run": "2022-11-17"}' --select website_analysis

# dbt run --profiles-dir ./ --target dev --vars '{"date": "2022-11-17"}' --full-refresh

#  output fully structured logs in JSON format
dbt --log-format json run

dbt run --profiles-dir ./ --target dev --full-refresh --select tag:daily

dbt docs generate --profiles-dir ./ --target dev
dbt docs serve --profiles-dir ./ --target dev