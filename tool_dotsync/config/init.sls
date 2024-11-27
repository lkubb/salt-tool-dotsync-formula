# vim: ft=sls

{#-
    Manages dotfiles configuration by

    * recursively syncing from a dotfiles repo
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as dotsync with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch %}


{%- for user in dotsync.users | selectattr("_dotsync.config") %}
{%-   set dotconfig = user.dotconfig if user.dotconfig is mapping else {} %}
{%-   for tool, target in user._dotsync.config.items() %}

{{ tool }} configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ target }}
    - source: {{ files_switch(
                    [tool],
                    lookup="{} configuration is synced for user '{}'".format(tool, user.name),
                    config=dotsync,
                    path_prefix=dotsync.lookup.source_roots.dotconfig,
                    files_dir="",
                    custom_data={"users": [user.name]},
                 )
              }}
    - context:
        user: {{ user | json }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
{%-     if dotconfig.get("file_mode") %}
    - file_mode: '{{ dotconfig.file_mode }}'
{%-     endif %}
    - dir_mode: '{{ dotconfig.get("dir_mode", "0700") }}'
    - clean: {{ dotconfig.get("clean", false) | to_bool }}
    - makedirs: true
  {%- endfor %}
{%- endfor %}
