dbt debug --profiles-dir ../ --target dev

dbt test --profiles-dir ../ --target dev

dbt build --profiles-dir ../ --target dev

dbt run --profiles-dir ../ --target dev
dbt run --profiles-dir ../ --target dev --vars '{"date": "2022-11-17"}'
dbt run --profiles-dir ../ --target dev --vars '{"date": "2022-11-17"}' --select website_analysis

# dbt run --profiles-dir ../ --target dev --vars '{"date": "2022-11-17"}' --full-refresh

dbt run --profiles-dir ../ --target dev --full-refresh --select tag:daily

dbt docs generate --profiles-dir ../ --target dev
dbt docs serve --profiles-dir ../ --target dev