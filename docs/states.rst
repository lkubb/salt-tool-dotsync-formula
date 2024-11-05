Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``tool_dotsync``
~~~~~~~~~~~~~~~~
*Meta-state*.

Performs all operations described in this formula according to the specified configuration.


``tool_dotsync.bin``
~~~~~~~~~~~~~~~~~~~~



``tool_dotsync.config``
~~~~~~~~~~~~~~~~~~~~~~~
Manages dotfiles configuration by

* recursively syncing from a dotfiles repo


``tool_dotsync.data``
~~~~~~~~~~~~~~~~~~~~~



``tool_dotsync.clean``
~~~~~~~~~~~~~~~~~~~~~~
*Meta-state*.

Undoes everything performed in the ``tool_dotsync`` meta-state
in reverse order.


``tool_dotsync.bin.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_dotsync.config.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the synced dotfiles.


``tool_dotsync.data.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~



