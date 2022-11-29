{% macro get_format_date(date, format) %}

    {% set date_obj = modules.datetime.datetime.strptime(date|string, "%Y-%m-%d") %}

    {%- if format == "YYYY" -%}

        {{ return(date_obj.strftime("%Y")) }}
    
    {%- elif format == "YYYYMM" -%}
        {{ return(date_obj.strftime("%Y%m")) }}
    
    {%- elif format == "YYYYMMDD" -%}

        {{ return(date_obj.strftime("%Y%m%D")) }}
    
    {%- endif -%}

    {{ return(19701101) }}

{% endmacro %}