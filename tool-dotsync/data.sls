{%- from 'tool-dotsync/map.jinja' import dotsync %}

{%- for user in dotsync.users | selectattr('dotsync.data', 'defined') %}
  {%- for tool in user.dotsync.data %}
    {%- if tool is mapping %}
      {%- set target = user.home ~ '/' ~ tool.values() | first %}
      {%- set tool = tool.keys() | first %}
    {%- else %}
      {%- set target = user._dotsync.datadir ~ tool %}
    {%- endif %}
{{ tool }} data is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ target }}
    - source:
      - salt://dotdata/{{ user.name }}/{{ tool }}
      - salt://dotdata/{{ tool }}
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
