{% macro get_date(date, debug=False) %}

    {%- if date == '1970-11-20'-%}
        {% set yesterday = (modules.datetime.datetime.now() - modules.datetime.timedelta(days=1)) %}
        {% set result = modules.datetime.datetime.strftime(yesterday, "%Y-%m-%d") %}
    {%- else -%}
        {% set result = date %}
    {%- endif -%}

    {%- if debug -%}
        {{ print(result) }}
    {%- endif -%}
    
    {{ return(result) }}

{% endmacro %}