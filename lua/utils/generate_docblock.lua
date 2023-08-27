local M = {}

    function M.makeDocblock(property, method)
        local docblock = {
            '    /**',
        }

        if method == 'getter' then
            if property.type ~= '' then
                table.insert(docblock, '     * @return ' .. property.type)
            else
                table.insert(docblock, '     * @return mixed')
            end
        end

        if method == 'setter' then
            if property.type ~= '' then
                table.insert(docblock, '     * @param ' .. property.type .. ' $value')
                table.insert(docblock, '     * @return void')
            else
                table.insert(docblock, '     * @param mixed $value')
                table.insert(docblock, '     * @return void')
            end
        end

        table.insert(docblock, '     */')

        return docblock
    end

return M
