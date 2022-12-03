dbt debug --profiles-dir ../ --target dev

dbt test --profiles-dir ../ --target dev

dbt build --profiles-dir ../ --target dev

# Test macro
dbt run-operation --profiles-dir ../ --target dev get_date --args '{date: 1970-11-20}'
dbt run-operation --profiles-dir ../ --target dev get_format_date --args '{date: 2022-12-31, format: YYYY, debug=True}'
dbt run-operation --profiles-dir ../ --target dev get_format_date --args '{date: 2022-01-31, format: YYYYMM, debug=True}'
dbt run-operation --profiles-dir ../ --target dev get_format_date --args '{date: 2022-11-01, format: YYYYMMDD, debug=True}'
dbt run-operation --profiles-dir ../ --target dev get_format_date --args '{date: 2022-11-20, format: YYYYMM01, debug=True}'
dbt run-operation --profiles-dir ../ --target dev get_format_date --args '{date: 2022-02-20, format: YYYYMM31, debug=True}'
dbt run-operation --profiles-dir ../ --target dev get_format_date --args '{date: 2022-04-11, format: YYYYMM31, debug=True}'
dbt run-operation --profiles-dir ../ --target dev get_format_date --args '{date: 2022-12-31, format: YYYYMM31, debug=True}'

# Run dbt
dbt run --profiles-dir ../ --target dev
dbt run --profiles-dir ../ --target dev --vars '{"date_run": "2022-11-17"}'
dbt run --profiles-dir ../ --target dev --vars '{"date_run": "2022-11-17"}' --select website_analysis
dbt run --profiles-dir ../ --target dev --vars '{"date_run": "2022-11-17"}' --select tag:website_analysis_tool

# to make dbt exit immediately if a single resource fails to build. If other models are in-progress 
# when the first model fails, then dbt will terminate the connections for these still-running models.
dbt --fail-fast run --profiles-dir ../ --target dev --vars '{"date_run": "2022-11-17"}' --select website_analysis

# dbt run --profiles-dir ../ --target dev --vars '{"date": "2022-11-17"}' --full-refresh

#  output fully structured logs in JSON format
dbt --log-format json run

dbt run --profiles-dir ../ --target dev --full-refresh --select tag:daily

dbt docs generate --profiles-dir ../ --target dev
dbt docs serve --profiles-dir ../ --target dev