{% macro get_date(date) %}

    {%- if date == '1970-11-20'-%}

        {% set yesterday = (modules.datetime.datetime.now() - modules.datetime.timedelta(1)) %}

        {% set _date = modules.datetime.datetime.strftime(yesterday, "%Y-%m-%d") %}

        {{ return(_date) }}

    {%- endif -%}
    
    {{ return(date) }}

{% endmacro %}