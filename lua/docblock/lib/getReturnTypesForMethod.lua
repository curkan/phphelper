local M = {}
    local function iterableReturnTypes(node)
        local tableReturns = {}

        for child in node:iter_children() do
            if child:type() == 'primitive_type' then
                local returnType = vim.treesitter.get_node_text(child, 0)

                table.insert(tableReturns, returnType)
            end
        end

        return tableReturns
    end

    function M.getReturnTypesForMethod(node)
        local returnsTable = {}

        local allReturnTypes = node:field('return_type')

        for _, returnType in pairs(allReturnTypes) do
            local returns = iterableReturnTypes(returnType)
            table.insert(returnsTable, returns)
        end

        return returnsTable
    end

return M

