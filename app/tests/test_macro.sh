DBT_DIR='~/projects/dbt-clickhouse/app/clickhouse_statistics'

cd ${DBT_DIR}
pwd

dbt run-operation --profiles-dir ../ --target dev get_date --args '{date: 1970-11-20}'
dbt run-operation --profiles-dir ../ --target dev get_date --args '{date: 1970-11-20, debug: True}'

dbt run-operation --profiles-dir ../ --target dev get_format_date --args '{date: 2022-12-31, format: YYYY}'
dbt run-operation --profiles-dir ../ --target dev get_format_date --args '{date: 2022-12-31, format: YYYY, debug: True}'
dbt run-operation --profiles-dir ../ --target dev get_format_date --args '{date: 2022-01-31, format: YYYYMM, debug: True}'
dbt run-operation --profiles-dir ../ --target dev get_format_date --args '{date: 2022-11-01, format: YYYYMMDD, debug: True}'
dbt run-operation --profiles-dir ../ --target dev get_format_date --args '{date: 2022-11-20, format: YYYYMM01, debug: True}'
dbt run-operation --profiles-dir ../ --target dev get_format_date --args '{date: 2022-02-20, format: YYYYMM31, debug: True}'
dbt run-operation --profiles-dir ../ --target dev get_format_date --args '{date: 2022-04-11, format: YYYYMM31, debug: True}'
dbt run-operation --profiles-dir ../ --target dev get_format_date --args '{date: 2022-12-31, format: YYYYMM31, debug: True}'


