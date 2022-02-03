# `dotsync` Formula
Syncs user configuration and data files from dotfiles repositories. This is for miscellaneous stuff that is not covered in one of the `tool-` formulae.

## Usage
Applying `tool-dotsync` will make sure the user's dotfiles are synced to the repository. It will recursively apply templates from
- `salt://dotconfig/<user>/<tool>` or
- `salt://dotconfig/<tool>`
to the user's config dir as well as templates from
- `salt://dotdata/<user>/<tool>` or
- `salt://dotdata/<tool>`
to the user's data dir.

You can also sync scripts from `salt://dotbin/<user>` or `salt://dotbin` to `$HOME/.local/bin` or a custom target.

The target folder will not be cleaned by default (ie files in the target that are absent from the user's dotconfig will stay).

## Configuration
### Pillar
#### General `tool` architecture
Since installing user environments is not the primary use case for saltstack, the architecture is currently a bit awkward. All `tool` formulas assume running as root. There are three scopes of configuration:
1. per-user `tool`-specific
  > e.g. generally force usage of XDG dirs in `tool` formulas for this user
2. per-user formula-specific
  > e.g. setup this tool with the following configuration values for this user
3. global formula-specific (All formulas will accept `defaults` for `users:username:formula` default values in this scope as well.)
  > e.g. setup system-wide configuration files like this

**3** goes into `tool:formula` (e.g. `tool:git`). Both user scopes (**1**+**2**) are mixed per user in `users`. `users` can be defined in `tool:users` and/or `tool:formula:users`, the latter taking precedence. (**1**) is namespaced directly under `username`, (**2**) is namespaced under `username: {formula: {}}`.

```yaml
tool:
######### user-scope 1+2 #########
  users:                         #
    username:                    #
      xdg: true                  #
      dotconfig: true            #
      formula:                   #
        config: value            #
####### user-scope 1+2 end #######
  formula:
    formulaspecificstuff:
      conf: val
    defaults:
      yetanotherconfig: somevalue
######### user-scope 1+2 #########
    users:                       #
      username:                  #
        xdg: false               #
        formula:                 #
          otherconfig: otherval  #
####### user-scope 1+2 end #######
```


#### User-specific
The following shows an example of `tool-dotsync` pillar configuration. Namespace it to `tool:users` and/or `tool:dotsync:users`.
```yaml
user:
  xdg: true           # sync files into xdg dirs (XDG_CONFIG_HOME / XDG_DATA_HOME) by default
  dotsync:
    # sync scripts etc to .local/bin or custom target
    bin: true         # or list of exact names
    bindir: .bin      # by default, bin files will be synced to $HOME/.local/bin. override that
    # sync config files from salt://dotconfig/<user>/<tool> or salt://dotconfig/<tool>
    config:
      - broot         # target folder: depending on user.xdg: XDG_CONFIG_HOME/broot or $HOME/.broot
      - ssh: .ssh     # overrides target to $HOME/.ssh
    # sync data files from salt://dotdata/<user>/<tool> or salt://dotconfig/<tool>
    data:
      - vim           # target folder: depending on user.xdg: XDG_DATA_HOME/vim or $HOME/.vim
      - zsh: .my/zsh  # overrides target to $HOME/.my/zsh
```

#### Formula-specific
```yaml
tools:
  dotsync:
    defaults:        # default tools whose config files should be synced
      config:
        - neofetch
```

## Todo
Nothing atm.

## See also
- https://github.com/blacs30/saltstack-config
