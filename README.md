# Shell Emulator

A super basic shell and filesystem emulation for a *nix type OS. All commands are shell builtins. No forking or threading. The "filesystem" is really nothing more then a few objects that emulate the basic structure of a *nix FS.

Commands all support basic piping with | and redirection with > and >>.

TODO next:
- commands:
    - rm
    - rmdir
    - whoami
    - mail
    - ssh
    - text editing (scary)
- Permissions!
- Ablity to cd into sub directories
- Save state of filesystem
- Initialize filesystem with text files as well
- Multiple commands with ; or &&
- Better support for renaming commands (e.g., say I don't want to call the manual pages command by its typical name)
- Better arg handling
