# hacking_game

A super basic shell and filesystem emulation currently. All commands are shell builtins. No forking or threading. The "filesystem" is really nothing more then a few objects that emulate the basic structure of a *nix FS. All of it is just stored in memory.

Commands all support basic piping of stdout/stdin to other commands with |. (e.g., `time | grep 19`.)

TODO next:
- commands:
    - rmdir
    - rm
    - touch
    - man
- Files
- differentiate between files and directories
- better handling for "available_commands"
- cd into multiple directories
- save state of filesystem
- multiple commands with ; or && (but not chaining stdout/stdin)
- support for stderr
- better interpretation of ".." and "." into cd and ls
- better support for renaming commands (e.g., say I don't want to call the manual pages command by its typical name)
- consider using curses