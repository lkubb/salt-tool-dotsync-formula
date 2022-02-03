{%- from 'tool-dotsync/map.jinja' import dotsync %}

{%- for user in dotsync.users | selectattr('dotsync.config', 'defined') %}
  {%- for tool in user.dotsync.config %}
{{ tool }} configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user._dotsync.confdir }}{{ tool }}
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
