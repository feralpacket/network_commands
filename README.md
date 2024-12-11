# network_commands
Random Network Commands - Notes To Self

Need a place to keep notes about random network commands.  I have been posting commands to Twitter for a while.  Some of the commands have brief explanations.  Some of the commands are undocumented.

## VIM
Started making changes to the VIM syntax configuration file for Cisco.  Calling it version .628 for now.

Drop cisco.vim into C:\Program Files\Vim\vim91\syntax or the syntax directory of wherever it's been installed.

The original file, version .627, can be found here.

https://www.vim.org/scripts/script.php?script_id=4624

Highlight cisco configuration files.
```
set syntax=cisco
```

Fix a font bug where italic characters get cut off.
```
set guifont=Consolas
```
