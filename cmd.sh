dbt debug --profiles-dir ~/Projects/dbt-clickhouse/ --target dev

dbt test --profiles-dir ~/Projects/dbt-clickhouse/ --target dev

dbt build --profiles-dir ~/Projects/dbt-clickhouse/ --target dev

dbt run --profiles-dir ~/Projects/dbt-clickhouse/ --target dev

dbt run --profiles-dir ~/Projects/dbt-clickhouse/ --target dev --vars '{"date": "2022-11-17"}'