.. _readme:

dotsync Formula
===============

Syncs user configuration and data files from dotfiles repositories. This is for miscellaneous stuff that is not covered in one of the ``tool`` formulae.

.. contents:: **Table of Contents**
   :depth: 1

Usage
-----
Applying ``tool-dotsync`` will make sure the user's dotfiles are synced from the repository. It will recursively apply templates from

* ``salt://<source_root>/<minion_id>/<user>/<package_xdg_name>``
* ``salt://<source_root>/<minion_id>/<package_xdg_name>``
* ``salt://<source_root>/<os_family>/<user>/<package_xdg_name>``
* ``salt://<source_root>/<os_family>/<package_xdg_name>``
* ``salt://<source_root>/default/<user>/<package_xdg_name>``
* ``salt://<source_root>/default/<package_xdg_name>``

to the user's target dir for every user that was configured. For details on the fileserver urls, see the comments in ``pillar.example`` or below in `User-specific`_.

The URL list above is in descending priority. This means user-specific configuration from wider scopes will be overridden by more system-specific general configuration.

This works for config (``<source_root>`` = ``dotconfig`` by default) and data (``<source_root>`` = ``dotconfig`` by default).

You can also sync scripts (``<source_root>`` = ``dotbin`` by default) in the same way as above, with the exception that Jinja templates are not rendered currently.

Configuration
-------------

This formula
~~~~~~~~~~~~
The general configuration structure is in line with all other formulae from the `tool` suite, for details see :ref:`toolsuite`. An example pillar is provided, see :ref:`pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in :ref:`map.jinja`.

User-specific
^^^^^^^^^^^^^
The following shows an example of ``tool_dotsync`` per-user configuration. If provided by pillar, namespace it to ``tool_global:users`` and/or ``tool_dotsync:users``. For the ``parameters`` YAML file variant, it needs to be nested under a ``values`` parent key. The YAML files are expected to be found in

1. ``salt://tool_dotsync/parameters/<grain>/<value>.yaml`` or
2. ``salt://tool_global/parameters/<grain>/<value>.yaml``.

.. code-block:: yaml

  user:

      # Force the usage of XDG directories for this user.
    xdg: true

    dotconfig:              # can be bool or mapping
      file_mode: '0600'     # default: keep destination or salt umask (new)
      dir_mode: '0700'      # default: 0700
      clean: false          # delete files in target. default: false

      # Persist environment variables used by this formula for this
      # user to this file (will be appended to a file relative to $HOME)
    persistenv: '.config/zsh/zshenv'

      # Add runcom hooks specific to this formula to this file
      # for this user (will be appended to a file relative to $HOME)
    rchook: '.config/zsh/zshrc'

      # This user's configuration for this formula. Will be overridden by
      # user-specific configuration in `tool_dotsync:users`.
      # Set this to `false` to disable configuration for this user.
    dotsync:
        # The purpose of this formula is to generally sync a user's
        # config/data/scripts from dotfiles repos.
        # For config, see the following sources (in descending priority):
        # salt://<source_root>/<minion_id>/<user>/<package_xdg_name>
        # salt://<source_root>/<minion_id>/<package_xdg_name>
        # salt://<source_root>/<os_family>/<user>/<package_xdg_name>
        # salt://<source_root>/<os_family>/<package_xdg_name>
        # salt://<source_root>/default/<user>/<package_xdg_name>
        # salt://<source_root>/default/<package_xdg_name>

        # Sync scripts etc. to `.local/bin` (or custom target).
        # Can be boolean or list of exact file names.
        # A list permits you to source scripts from different points
        # in the above priority list.
        # The fileserver source root is `dotbin` by default.
      bin: true
        # By default, bin files will be synced to `$HOME/.local/bin`.
        # Override that here.
      bindir: .bin

        # Sync config files from a dotfiles repo.
        # The fileserver source root is `dotconfig` by default.
      config:
            # Source: see above, `package_xdg_name` = `broot`
            # Target:
            #   if user.xdg: XDG_CONFIG_HOME/broot
            #   else:        ~/.broot
        - broot
            # This overrides target to ~/.ssh
        - ssh: .ssh
            # This overrides target to ~/
        - zsh: ''

        # Sync data files from a dotfiles repo.
        # The fileserver source root is `dotdata` by default.
      data:
            # Source: see above,  `package_xdg_name` = `vim`
            # Target:
            #   if user.xdg: XDG_DATA_HOME/vim
            #   else:        ~/.vim
        - vim
            # This overrides target to ~/.my/zsh
        - zsh: .my/zsh

        # Settings for file.recurse.
        # Those are the equivalents of the global ``dotsync`` parameter,
        # which is respected by this formula as well.
      dotbin:
        clean: false
        dir_mode: '0700'
        file_mode: '0700'
      dotdata:
        clean: false
        dir_mode: '0755'
        file_mode: '0644'

Formula-specific
^^^^^^^^^^^^^^^^

.. code-block:: yaml

  tool_dotsync:

      # Default formula configuration for all users.
    defaults:
      bin: default value for all users

<INSERT_STATES>

Development
-----------

Contributing to this repo
~~~~~~~~~~~~~~~~~~~~~~~~~

Commit messages
^^^^^^^^^^^^^^^

Commit message formatting is significant.

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``.

.. code-block:: console

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.

Testing
~~~~~~~

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

  $ gem install bundler
  $ bundle install
  $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``tool_dotsync`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.

See also
--------
* https://github.com/blacs30/saltstack-config
