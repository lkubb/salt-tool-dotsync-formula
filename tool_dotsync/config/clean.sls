# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as dotsync with context %}


{%- for user in dotsync.users | selectattr('_dotsync.config') %}
{%-   for tool, target in user._dotsync.config.items() %}

{{ tool }} configuration is absent for user '{{ user.name }}':
  file.absent:
    - name: {{ target }}
  {%- endfor %}
{%- endfor %}
