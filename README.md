# PHPHelper
Plugin for neovim, which will help in creating dock blocks, generating getters and setters for the PHP programming language

Create docblock at cursor
![PHPHelper gif](https://github.com/curkan/phphelper/blob/master/phphelper.gif)

Generate all docblock for this class (While it only works with methods)
![PHPHelpergenerate gif](https://github.com/curkan/phphelper/blob/master/phphelper_generate_all_docblock.gif)

Generate getter and setter for class
![PHPHelpergenerate gif](https://github.com/curkan/phphelper/blob/master/phphelper_generate_getter_and_setter.gif)

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

There are two key bindings provided by default (create php docblock):

    <leader>p

you can override:

    vim.api.nvim_set_keymap('n', '<leader>p', '<cmd>:PHPAddDocblock()<cr>', default_opts)

Commands: 

    :PHPAddDocblock
    :PHPGenerateAllDocblock
    :PHPGenerateGetterAndSetter
    :PHPGenerateGetter
    :PHPGenerateSetter

