{% macro get_format_date(date, format, debug=False) %}

    {% set date_obj = modules.datetime.datetime.strptime(date|string, "%Y-%m-%d") %}

    {%- if format == "YYYY" -%}
        {% set result = date_obj.strftime("%Y") %}
    {%- elif format == "YYYYMM" -%}
        {% set result = date_obj.strftime("%Y%m") %}
    {%- elif format == "YYYYMMDD" -%}
        {% set result = date_obj.strftime("%Y%m%D") %}
    {%- elif format == "YYYYMM01" -%}
        {% set result = date_obj.strftime("%Y%m01") %}
    {%- elif format == "YYYYMM31" -%}
        {% set next_month = date_obj.replace(day=28) + modules.datetime.timedelta(days=4) %}
        {% set result = (next_month - modules.datetime.timedelta(days=next_month.day)).strftime("%Y%m%d") %}
    {%- else -%}
        {% set result = "19701101" %}
    {%- endif -%}

    {%- if debug -%}
        {{ print(result) }}
    {%- endif -%}

    {{ return(~ date " (format: " ~ format "): " ~ result) }}

{% endmacro %}