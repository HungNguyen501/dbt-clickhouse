#!/bin/bash

yesterday=`date -d "today -1 day" +"%Y-%m-%d"`

if [ -n "${1}" ];
then 
    SELECT=${1}
    if [ -z "${2}" ] && [ -z "${3}" ];
    then
        dbt --log-format json run --profiles-dir ./ --target dev --vars "{'run_date': '${yesterday}'}" --select ${SELECT} | alert_bot/main.py
    
    elif [ -n "${2}" ];
    then
        if [ -n "${3}" ];
        then
            if [ "${2}" \> "${3}" ];
            then
                echo "start_date > end_date (${2} > ${3}), exit 1"
                exit 1
            fi

            run_date=${3}
        else
            run_date=${yesterday}
        fi

        start_date=${2}
        while [ "${run_date}" \> "${start_date}" ] || [ "${run_date}" = "${start_date}" ]; 
        do
            echo "RUN DATE ***: ${run_date}"
            dbt --log-format json run --profiles-dir ./ --target dev --vars "{'run_date': '${run_date}'}" --select ${SELECT} | alert_bot/main.py

            if [ $? -ne 0 ];
            then
                echo "dbt_job failed at ${run_date}, exit 1"
                exit 1
            fi

            run_date=`date -d "${run_date} -1 day" "+%Y-%m-%d"`
        done
    fi
else
    echo "Please fill first param as model or tag"
    exit 1
fi
