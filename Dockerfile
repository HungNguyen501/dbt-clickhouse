FROM python:3.7-slim-buster

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y tzdata \
    && cp /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime \
    && echo "Asia/Ho_Chi_Minh" >  /etc/timezone \
    && apt-get remove -y tzdata
 
RUN apt-get install -y git libpq-dev python-dev python3-pip \
    && apt-get remove python-cffi

COPY requirements.txt /

RUN pip install --upgrade pip wheel setuptools \
    && pip install --upgrade cffi \
    && pip install -r /requirements.txt

COPY app /app
WORKDIR /app
