{% macro get_date(date) %}
   {%- if date == '1970-11-20'-%}
        {% set yesterday = (modules.datetime.datetime.now() - modules.datetime.timedelta(1)) %}
        {{ return(modules.datetime.datetime.strftime(yesterday, "%Y-%m-%d")) }}
   {%- endif -%}
  
  {{ return(date) }}
{% endmacro %}