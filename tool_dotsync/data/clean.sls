# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as dotsync with context %}


{%- for user in dotsync.users | selectattr("_dotsync.data") %}
{%-   for tool, target in user._dotsync.data.items() %}

{{ tool }} data is absent for user '{{ user.name }}':
  file.recurse:
    - name: {{ target }}
  {%- endfor %}
{%- endfor %}
