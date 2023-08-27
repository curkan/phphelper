# PHPHelper
Plugin for NeoVim to create dock-blocks

Create dockblock at cursor
![PHPHelper gif](https://github.com/curkan/phphelper/blob/master/phphelper.gif)


Generate getter and setter for class
![PHPHelpergenerate gif](https://github.com/curkan/phphelper/blob/master/phphelper_generate.gif)

Commands: 

    :PHPAddDockBlock
    :PHPGenerateAll
    :PHPGenerateGetter
    :PHPGenerateSetter

## Shortcuts

by default for create dock block: 

    <leader>p

you can override:

	vim.api.nvim_set_keymap('n', '<leader>p', '<cmd>:AddPhpDockBlock()<cr>', default_opts)
