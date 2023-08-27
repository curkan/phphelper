local M = {}

    -- Основная функция для генерации докблоков
    function M.generateAllDocblock()
        local ts_utils = require 'nvim-treesitter.ts_utils'
        local bufnr = vim.api.nvim_get_current_buf()
        -- local getMethodNode = require('lua.docblock.lib.getMethodNode')
        -- local cursor_node = ts_utils.get_node_at_cursor()
        local parser = vim.treesitter.get_parser(bufnr, 'php')
        local root = parser:parse()[1]

        local function findClassDeclaration(node)
            if node == nil then
                return nil
            end

            if node:type() == 'class_declaration' then
                return node
            else 
                findClassDeclaration(node:child())
            end
        end

        local class = nil

        for node in root:root():iter_children() do
            class = findClassDeclaration(node)

            if class ~= nil then
                break
            end
        end

        if class ~= nil then
            local getMethodNode = require('docblock.lib.getMethodNode')
            local methodNodesTable = getMethodNode.getMethodNode(class)
            local iterableCountDocblock = 0

            local tableNodeWithParamsAndReturnTypes = {}

            -- Получили все методы
            for _, node in ipairs(methodNodesTable) do
                local formal_module = require('docblock.lib.getFormalParametrsForMethod')
                local formalParametrs = formal_module.getFormalParametrsForMethod(node)[1]
                local methodParametrs = {}
                local methodReturnTypes = {}

                methodParametrs = formalParametrs

                local return_module = require('docblock.lib.getReturnTypesForMethod')
                local returnTypes = return_module.getReturnTypesForMethod(node)

                for _, returns in ipairs(returnTypes) do
                    methodReturnTypes = returns
                end

                table.insert(tableNodeWithParamsAndReturnTypes, {node = node, parametrs = methodParametrs, returnTypes = methodReturnTypes})
            end

            for _, node in ipairs(tableNodeWithParamsAndReturnTypes) do
                local printer = require('docblock.lib.printDocblock')
                iterableCountDocblock = printer.print(bufnr, node.node, node.parametrs, node.returnTypes, iterableCountDocblock)
            end
        end

    end


return M
