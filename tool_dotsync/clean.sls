# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``tool_dotsync`` meta-state
    in reverse order.
#}

include:
  - .bin.clean
  - .config.clean
  - .data.clean
