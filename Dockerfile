FROM python:3.7-slim-buster

ENV DBT_HOME=/app/clickhouse_statistics/

RUN apt-get update \
    && apt-get install -y tzdata \
    && cp /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime \
    && echo "Asia/Ho_Chi_Minh" >  /etc/timezone \
    && apt-get remove -y tzdata
 
COPY requirements.txt /
COPY app /app

RUN apt-get install -y -q git libpq-dev python-dev python3-pip \
    && apt-get remove python-cffi \
    && pip install --upgrade pip wheel setuptools \
    && pip install --upgrade cffi \
    && pip install -r /requirements.txt

WORKDIR ${DBT_HOME}

# Expose port for dbt docs
EXPOSE 8080