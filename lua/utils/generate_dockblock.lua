local M = {}

    function M.makeDockBlock(property, method)
        local dockblock = {
            '    /**',
        }

        if method == 'getter' then
            if property.type ~= '' then
                table.insert(dockblock, '     * @return ' .. property.type)
            else
                table.insert(dockblock, '     * @return mixed')
            end
        end

        if method == 'setter' then
            if property.type ~= '' then
                table.insert(dockblock, '     * @param ' .. property.type .. ' $value')
                table.insert(dockblock, '     * @return void')
            else
                table.insert(dockblock, '     * @param mixed $value')
                table.insert(dockblock, '     * @return void')
            end
        end

        table.insert(dockblock, '     */')

        return dockblock
    end

return M
