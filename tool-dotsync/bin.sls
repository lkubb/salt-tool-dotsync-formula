{%- from 'tool-dotsync/map.jinja' import dotsync %}

{%- for user in dotsync.users | selectattr('dotsync.bin', 'defined') | selectattr('dotsync.bin') %}
  {%- if user.dotsync.bin is sameas True %}

Executables are synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user.dotsync.get('bindir', user.home ~ '/.local/bin') }}
    - source:
        - salt://dotbin/{{ user.name }}
        - salt://dotbin
    - user: {{ user.name }}
    - group: {{ user.group }}
    - file_mode: keep
    - dir_mode: '0700'
    - makedirs: True
  {%- else %}
    {%- for exe in user.dotsync.bin %}

'{{ exe }}' is synced to bin dir for user '{{ user.name }}':
  file.recurse:
    - name: {{ user.dotsync.get('bindir', user.home ~ '/.local/bin') }}/{{ exe }}
    - source:
        - salt://dotbin/{{ user.name }}/{{ exe }}
        - salt://dotbin/{{ exe }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - file_mode: keep
    - dir_mode: '0700'
    - makedirs: True
    {%- endfor %}
  {%- endif %}
{%- endfor %}
