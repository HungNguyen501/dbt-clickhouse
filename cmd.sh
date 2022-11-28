dbt debug --profiles-dir ../ --target dev

dbt test --profiles-dir ../ --target dev

dbt build --profiles-dir ../ --target dev

dbt run --profiles-dir ../ --target dev
dbt run --profiles-dir ../ --target dev --vars '{"date": "2022-11-17"}'
dbt run --profiles-dir ../ --target dev --vars '{"date": "2022-11-17"}' --select website_analysis

# to make dbt exit immediately if a single resource fails to build. If other models are in-progress 
# when the first model fails, then dbt will terminate the connections for these still-running models.
dbt --fail-fast run --profiles-dir ../ --target dev --vars '{"date": "2022-11-17"}' --select website_analysis

# dbt run --profiles-dir ../ --target dev --vars '{"date": "2022-11-17"}' --full-refresh

dbt --log-format json run

#  output fully structured logs in JSON format
dbt run --profiles-dir ../ --target dev --full-refresh --select tag:daily

dbt docs generate --profiles-dir ../ --target dev
dbt docs serve --profiles-dir ../ --target dev