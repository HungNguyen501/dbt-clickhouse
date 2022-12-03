{% macro template_unit_test(func, expected_output, args=[]) %}

    {% if args|length==1 %}
        {% set result = func(args[0]) %}
    {% elif args|length==2 %}
        {% set result = func(args[0], args[1]) %}
    {% elif args|length==3 %}
        {% set result = func(args[1], args[2], args[3]) %}
    {% endif %}

    {% if result != expected_output %}
        {{ exceptions.raise_compiler_error("[Test Failed] get_date | args: " ~ args ~ " | expected_output: " ~ expected_output ~ " | result: " ~ result) }}
    {% endif %}

{% endmacro %}

{% macro run_unit_tests() %}
    
    -- Test get_date
    {{ template_unit_test(func=get_date, expected_output="2022-12-02", args=["1970-11-20"]) }}
    {{ template_unit_test(func=get_date, expected_output="2022-12-03", args=["2022-12-03"]) }}

    -- Test get_date_format
    {{ template_unit_test(func=get_format_date, expected_output="2022", args=["2022-12-31","YYYY"]) }}
    {{ template_unit_test(func=get_format_date, expected_output="202212", args=["2022-12-03","YYYYMM"]) }}
    {{ template_unit_test(func=get_format_date, expected_output="20220101", args=["2022-01-01","YYYYMMDD"]) }}
    {{ template_unit_test(func=get_format_date, expected_output="20221201", args=["2022-12-31","YYYYMM01"]) }}
    {{ template_unit_test(func=get_format_date, expected_output="20221231", args=["2022-12-31","YYYYMM31"]) }}
    {{ template_unit_test(func=get_format_date, expected_output="20220228", args=["2022-02-20","YYYYMM31"]) }}
    {{ template_unit_test(func=get_format_date, expected_output="20220430", args=["2022-04-20","YYYYMM31"]) }}

    {{ print("All testcases passed") }}

{% endmacro %}