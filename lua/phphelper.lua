local func = require("lib.func")
local class = require("lib.class")
local variable = require("lib.variable")
local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}

function add_docblock()
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

function generateGetterAndSetter(method)
    local ts = require('utils.generate')
    ts.generate_getters_setters(method)
end

function generateAllDocblock()
    local docblock = require('docblock.docblock')
    docblock.generateAllDocblock()
end


vim.cmd("command! PHPAddDocblock lua add_docblock()")
vim.cmd("command! PHPGenerateAllDocblock lua generateAllDocblock()")
vim.cmd("command! PHPGenerateGetterAndSetter lua generateGetterAndSetter()")
vim.cmd("command! PHPGenerateGetter lua generateGetterAndSetter('getter')")
vim.cmd("command! PHPGenerateSetter lua generateGetterAndSetter('setter')")
map('n', '<leader>p', '<cmd>lua add_docblock()<cr>', default_opts)
