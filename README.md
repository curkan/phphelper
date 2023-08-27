# PHPHelper
Plugin for NeoVim to create dock-blocks

![PHPHelper gif](https://github.com/curkan/phphelper/blob/master/phphelper.gif)

Command for add dock-block:

    :AddPhpDockBlock

## Shortcuts

by default: 

    <leader>p

you can override:

	vim.api.nvim_set_keymap('n', '<leader>p', '<cmd>:AddPhpDockBlock()<cr>', default_opts)
