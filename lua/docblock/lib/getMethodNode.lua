local M = {}

    function M.getMethodNode(node)
        local tableNodesMethod = {}

        local function getMethod(my_node)
            for child in my_node:iter_children() do
                if child:type() == 'method_declaration' then
                    local prevNode = child:prev_sibling()
                    if prevNode ~= nil then
                        if prevNode:type() == 'comment' then
                            goto continue
                        end
                    end

                    table.insert(tableNodesMethod, child)
                else
                    getMethod(child)
                end
                ::continue::
            end

            return tableNodesMethod
        end

        tableNodesMethod = getMethod(node)
        return tableNodesMethod
    end

return M
