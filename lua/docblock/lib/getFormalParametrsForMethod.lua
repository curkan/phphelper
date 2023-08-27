local M = {}
    local function iterableFormalParametrs(node)
        local tableParamets = {}
        for child in node:iter_children() do
            if child:type() == 'simple_parameter' then
                local type = child:field('type')[1]
                local name = child:field('name')[1]

                if type ~= nil then
                    type = vim.treesitter.get_node_text(type, 0)
                end

                if name ~= nil then
                    name = vim.treesitter.get_node_text(name, 0)
                end

                table.insert(tableParamets, {type = type, name = name})
            end
        end

        return tableParamets
    end

    function M.getFormalParametrsForMethod(node)
        local parametrs = {}

        local allParametrs = node:field('parameters')

        -- print(#allParametrs)
        for _, nodeParametrs in pairs(allParametrs) do
            -- formal_parametrs
            local params = iterableFormalParametrs(nodeParametrs)
            table.insert(parametrs, params)
        end

        return parametrs
    end

return M
