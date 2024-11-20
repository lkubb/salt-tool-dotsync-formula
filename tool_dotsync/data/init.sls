# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as dotsync with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch %}


{%- for user in dotsync.users | selectattr("_dotsync.data") %}
{%-   for tool, target in user._dotsync.data.items() %}

{{ tool }} data is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ target }}
    - source: {{ files_switch(
                    [tool],
                    lookup="{} data is synced for user '{}'".format(tool, user.name),
                    config=dotsync,
                    path_prefix=dotsync.lookup.source_roots.dotdata,
                    custom_data={"users": [user.name]},
                 )
              }}
    - context:
        user: {{ user | json }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
    - file_mode: '{{ user.dotsync.dotdata.file_mode }}'
    - dir_mode: '{{ user.dotsync.dotdata.dir_mode }}'
    - clean: {{ user.dotsync.dotdata.clean | to_bool }}
    - makedirs: true
  {%- endfor %}
{%- endfor %}
