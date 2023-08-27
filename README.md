# PHPHelper
Plugin for neovim, which will help in creating dock blocks, generating getters and setters for the PHP programming language

Create dockblock at cursor
![PHPHelper gif](https://github.com/curkan/phphelper/blob/master/phphelper.gif)


Generate getter and setter for class
![PHPHelpergenerate gif](https://github.com/curkan/phphelper/blob/master/phphelper_generate.gif)

## Setup

phphelper uses the `nvim-treesitter` plugin. You can install both by doing (vim-plug):

```vim
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'curkan/phphelper'
```

Connect the plugin

```lua
require "phphelper"
```

## Usage

There are two key bindings provided by default (create php dockblock):

    <leader>p

you can override:

    vim.api.nvim_set_keymap('n', '<leader>p', '<cmd>:AddPhpDockBlock()<cr>', default_opts)

Commands: 

    :PHPAddDockBlock
    :PHPGenerateAll
    :PHPGenerateGetter
    :PHPGenerateSetter

