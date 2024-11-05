# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as dotsync with context %}


{%- for user in dotsync.users | selectattr("dotsync.bin", "defined") | selectattr("dotsync.bin") %}
{%-   if user.dotsync.bin is sameas true %}

Executables are synced for user '{{ user.name }}':
  file.absent:
    - name: {{ user._dotsync.bindir }}

{%-   else %}
{%-     for exe in user.dotsync.bin %}

'{{ exe }}' is synced to bin dir for user '{{ user.name }}':
  file.absent:
    - name: {{ user._dotsync.bindir | path_join(exe) }}
{%-     endfor %}
{%-   endif %}
{%- endfor %}
