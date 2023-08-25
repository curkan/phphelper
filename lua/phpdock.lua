local func = require("lib.func")
local class = require("lib.class")
local variable = require("lib.variable")
local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}

function add_dockblock()
    local lnum = vim.fn.line('.')
    local indent = vim.fn.indent(lnum)
    local line = vim.fn.getline(lnum)

    if func.get_function(line) ~= nil then
        func.create(line, indent, lnum)
    elseif next(class.get_class(line)) ~= nil then
        local class_info = class.get_class(line)
        class.create(line, indent, lnum, class_info)
    elseif next(variable.get_variable(line)) ~= nil then
        local variable_info = variable.get_variable(line)
        variable.create(line, indent, lnum, variable_info)
    end
end

vim.cmd("command! AddPhpDockBlock lua add_dockblock()")
map('n', '<leader>p', '<cmd>lua add_dockblock()<cr>', default_opts)

