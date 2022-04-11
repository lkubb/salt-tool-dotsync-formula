# -*- coding: utf-8 -*-
# vim: ft=yaml
---
tool_global:
  users:
    user:
      completions: .completions
      configsync: true
      persistenv: .bash_profile
      rchook: .bashrc
      xdg: true
      dotsync:
        bin: true
        bindir: .bin
        config:
          - broot
          - ssh: .ssh
          - zsh: ''
        data:
          - vim
          - zsh: .my/zsh
        dotbin:
          clean: false
          dir_mode: '0700'
          file_mode: '0700'
        dotdata:
          clean: false
          dir_mode: '0755'
          file_mode: '0644'
tool_dotsync:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value

    pkg:
      name: dotsync
    paths:
      confdir: '.dotsync'
      conffile: 'config'
      xdg_dirname: 'dotsync'
      xdg_conffile: 'config'
    source_roots:
      dotbin: dotbin
      dotconfig: dotconfig
      dotdata: dotdata

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://tool_dotsync/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   tool-dotsync-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
