{% macro formatted_date(date) %}
  {% set date_obj = modules.datetime.datetime.strptime(date|string, "%Y%m%d") %}
  {{ return(date_obj.strftime("%Y-%m-%d")) }}
{% endmacro %}