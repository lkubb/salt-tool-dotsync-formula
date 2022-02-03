{%- from 'tool-dotsync/map.jinja' import dotsync %}

{%- for user in dotsync.users | selectattr('dotsync.config', 'defined') %}
  {%- for tool in user.dotsync.config %}
    {%- if tool is mapping %}
      {%- set target = user.home ~ '/' ~ tool.values() | first %}
      {%- set tool = tool.keys() | first %}
    {%- else %}
      {%- set target = user._dotsync.confdir ~ tool %}
    {%- endif %}
{{ tool }} configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ target }}
    - source:
      - salt://dotconfig/{{ user.name }}/{{ tool }}
      - salt://dotconfig/{{ tool }}
    - context:
        user: {{ user }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
    - file_mode: keep
    - dir_mode: '0700'
    - makedirs: True
  {%- endfor %}
{%- endfor %}
