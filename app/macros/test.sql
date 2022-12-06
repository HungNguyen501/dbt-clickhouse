{% macro test() %}
    -- {{ print(run_started_at.astimezone(modules.pytz.timezone('Asia/Ho_Chi_Minh')).strftime('%Y-%m-%d_%H:%M:%S.%f')) }}
    {{ print(get_monthly_tag()) }}
{% endmacro %}

-- returns current hour in YYYY-MM-DD-HH format,
-- optionally offset by N days (-N or +N) or M hours (-M or +M)
{%- macro current_hour(offset_days=0, offset_hours=0) -%}
  {%- set now = modules.datetime.datetime.now(modules.pytz.utc) -%}
  {%- set dt = now + modules.datetime.timedelta(days=offset_days, hours=offset_hours) -%}
  {{- dt.strftime("%Y-%m-%d-%H") -}}
{%- endmacro -%}

-- returns current day in YYYY-MM-DD format,
-- optionally offset by N days (-N or +N) or M hours (-M or +M)
{%- macro today(offset_days=0, offset_hours=0) -%}
  {{- current_hour(offset_days, offset_hours)[0:10] -}}
{%- endmacro -%}

-- accepts a timestamp string and returns a timestamo string
-- formatted like 'YYYY-MM-DD HH24:MI:SS.US', e.g. '2019-11-02 06:11:42.690000'
{%- macro dt_to_utc(ts_string) -%}
  TO_CHAR({{ ts_string }}::TIMESTAMPTZ, 'YYYY-MM-DD HH24:MI:SS.US')
{%- endmacro -%}