# keyboard.vim

A plugin help switch keymapping for different keyboard layout.

## Features

- [x] customizable paths for keymapping files
- [x] autocommand for resourcing current layout keymappings when detecting changes on current layout setting
- [x] Tab completion for layouts in COMMAND mode

## Installation

Use `Vim-plug`:

```
Plug 'tizee/keyboard.vim'
```

## Usage

First, define your keymappings for different keyboard layout in separated vim files.

For example:

```vimscript
let g:keyboard_autoresource=1
if $COLEMAK_KEYBOARD == 1
let g:keyboard_default_layout='colemak'
else
let g:keyboard_default_layout='qwerty'
endif
let g:keyboard_layout_paths = {
      \  'colemak': expand("$HOME/.config/nvim/keyboard/colemak.vim"),
      \  'qwerty': expand("$HOME/.config/nvim/keyboard/qwerty.vim")
      \ }
```

Then you could switch to the layout with:

```vimscript
:Keyboard [layout_name]
```

## How it works?

It is very straightfowrad that this plugin only source the keymapping you defined earlier.
