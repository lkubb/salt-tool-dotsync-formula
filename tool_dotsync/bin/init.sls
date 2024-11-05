# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as dotsync with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch %}


{%- for user in dotsync.users | selectattr("dotsync.bin", "defined") | selectattr("dotsync.bin") %}
{%-   if user.dotsync.bin is sameas true %}

Executables are synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user._dotsync.bindir }}
    - source: {{ files_switch(
                [""],
                default_files_switch=["id", "os_family"],
                override_root=dotsync.lookup.source_roots.dotbin,
                opt_prefixes=[user.name]) }}
    - context:
        user: {{ user | json }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - file_mode: '{{ user.dotsync.dotbin.file_mode }}'
    - dir_mode: '{{ user.dotsync.dotbin.dir_mode }}'
    - clean: {{ user.dotsync.dotbin.clean | to_bool }}
    - makedirs: true

{%-   else %}
{%-     for exe in user.dotsync.bin %}

'{{ exe }}' is synced to bin dir for user '{{ user.name }}':
  file.managed:
    - name: {{ user._dotsync.bindir | path_join(exe) }}
    - source: {{ files_switch(
                [exe],
                default_files_switch=["id", "os_family"],
                override_root=dotsync.lookup.source_roots.dotbin,
                opt_prefixes=[user.name]) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - file_mode: '{{ user.dotsync.dotbin.file_mode }}'
    - dir_mode: '{{ user.dotsync.dotbin.dir_mode }}'
    - makedirs: true
{%-     endfor %}
{%-   endif %}
{%- endfor %}
