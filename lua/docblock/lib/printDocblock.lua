local M = {}

    local function generateDocblock(method, parameters, returnTypes)
        local docblock = {
            '    /**',
        }

        for _, parametr in pairs(parameters) do
            table.insert(
                docblock, '     * param '
                .. (parametr.type ~= nil and parametr.type .. ' ' or '')
                .. (parametr.name ~= nil and parametr.name or '')
            )
        end

        if returnTypes == nil then
            return
        end

        if next(returnTypes) ~= nil then
            local countReturnTypes = #returnTypes
            local returnString = ''

            if countReturnTypes > 1 then
                returnString = table.concat(returnTypes, '|')
            else
                returnString = returnTypes[1]
            end

            table.insert(
                docblock, '     * return ' .. returnString
            )
        end

        table.insert(docblock, '     */')

        return docblock
    end

    function M.print(bufnr, method, parameters, returnTypes, iterableCountDocblock)
        local docblock = generateDocblock(method, parameters, returnTypes)

        if docblock == nil then
            return 0
        end

        vim.api.nvim_buf_set_lines(bufnr, method:start() + iterableCountDocblock, method:start() + iterableCountDocblock, false, docblock)

        iterableCountDocblock = iterableCountDocblock + #docblock

        return iterableCountDocblock
    end

return M

