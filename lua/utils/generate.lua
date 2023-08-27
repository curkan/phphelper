local M = {}

local function capitalizeFirstLetter(str)
    return str:gsub("^%l", string.upper)
end

local function getMethodName(node)
    local name = ''

    if node:type() == 'name' then
        name = vim.treesitter.get_node_text(node, 0)
    end

    return name
end

local function getPropertyType(node)
    local type = ''

    if node:type() == 'union_type' then
        type = vim.treesitter.get_node_text(node, 0)
    end

    return type
end

local function getPropertyName(node)
    for child in node:iter_children() do
        local name = ''

        if child:type() == 'variable_name' then
            name = vim.treesitter.get_node_text(child:child(1), 0)
        end

        return name
    end
end

local function writeGetter(bufnr, property, existing_getters, last_brace_index, method)
 
    -- Генерируем DocBlock
    local docblock_module = require('utils.generate_docblock')
    local docblock = {}
    docblock = docblock_module.makeDocblock(property, method)

    local getter_name = 'get' .. capitalizeFirstLetter(property.name)
    local getter_type = property.type

    if not existing_getters[getter_name] then
        -- Вставляем геттер
        local getter_code = {
        '    public function ' .. getter_name .. '()' .. (getter_type ~= '' and ': ' .. getter_type or ''),
        '    {',
        '        return $this->' .. property.name .. ';',
        '    }',
        ''
        }

        local getter_index = last_brace_index
        local tableGetter = {}
        table.move(docblock, 1, #docblock, 1, tableGetter)
        table.move(getter_code, 1, #getter_code, #docblock + 1, tableGetter)

        vim.api.nvim_buf_set_lines(bufnr, getter_index, getter_index, false, tableGetter)
    end
end

local function writeSetter(bufnr, property, existing_setters, last_brace_index, method)
    -- Генерируем DocBlock
    local docblock_module = require('utils.generate_docblock')
    local docblock = {}
    docblock = docblock_module.makeDocblock(property, method)


    local setter_name = 'set' .. capitalizeFirstLetter(property.name)
    local setter_type = property.type

    if not existing_setters[setter_name] then
        -- Вставляем сеттер
        local setter_code = {
        '    public function ' .. setter_name  .. '(' .. (setter_type ~= '' and (setter_type .. ' ') or '') .. '$value)'  .. ': void',
        '    {',
        '        $this->' .. property.name .. ' = $value;',
        '    }',
        ''
        }

        local setter_index = last_brace_index

        local tableSetter = {}
        table.move(docblock, 1, #docblock, 1, tableSetter)
        table.move(setter_code, 1, #setter_code, #docblock + 1, tableSetter)

        vim.api.nvim_buf_set_lines(bufnr, setter_index, setter_index, false, tableSetter)
    end
end

function M.generate_getters_setters(method)
    local bufnr = vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(bufnr, 'php')
    local root = parser:parse()[1]
    local class_node = nil
    local existing_getters = {}
    local existing_setters = {}

    -- Находим узел класса, в котором нужно добавить геттеры и сеттеры
    for node in root:root():iter_children() do
        if node:type() == 'class_declaration' then
            class_node = node
            break
        end
    end


    -- Найдите все проперти в файле
    local properties = {}

    local function find_properties(node)
        for child in node:iter_children() do
            if child:type() == 'property_declaration' then
                local index = 0
                local name = ''
                local type = ''

                -- Если метод статический, то для него не делаем сеттеры и геттеры
                if child:child(1):type() == 'static_modifier' then
                    goto continue
                elseif child:child(2):type() == 'static_modifier' then
                    goto continue
                end

                if child:child(1):type() == 'union_type' then
                    type = getPropertyType(child:child(1))
                elseif child:child(2):type() == 'union_type' then
                    type = getPropertyType(child:child(2))
                elseif (child:child(3) ~= nil and child:child(3):type() or '') == 'union_type' then
                    type = getPropertyType(child:child(3))
                end


                if child:child(1):type() == 'property_element' then
                    index = 1
                elseif child:child(2):type() == 'property_element' then
                    index = 2
                elseif (child:child(3) ~= nil and child:child(3):type() or '') == 'property_element' then
                    index = 3
                end

                local property = child:child(index)
                    if property:type() == 'property_element' then
                        name = getPropertyName(property)
                    end

                    table.insert(properties, {name = name, type = type})
                    else
                find_properties(child)
            end
            ::continue::
        end
    end
    find_properties(root:root())


    -- Находим индекс последней фигурной скобки класса
    local last_brace_index = class_node:end_()
        for node in class_node:iter_children() do
        if node:type() == '}' and node:end_() > last_brace_index then
            last_brace_index = node:end_()
        end
    end

    -- Находим методы и сохраняем их
    -- Чтобы не добавлять геттеры и сеттеры, если такие функции уже есть
    local function find_methods(node)
        for child in node:iter_children() do
            if child:type() == 'method_declaration' then
                local method_name = nil

                if child:child(1):type() == 'name' then
                    method_name = getMethodName(child:child(1))
                elseif child:child(2):type() == 'name' then
                    method_name = getMethodName(child:child(2))
                elseif (child:child(3) ~= nil and child:child(3):type() or '') == 'name' then
                    method_name = getMethodName(child:child(3))
                end

                if method_name ~= nil then
                    if method_name:sub(1, 3) == 'get' then
                        existing_getters[method_name] = true
                    elseif method_name:sub(1, 3) == 'set' then
                        existing_setters[method_name] = true
                    end
                end
            else
                find_methods(child)
            end
        end
    end

    find_methods(class_node)

  -- Генерируйте геттеры и сеттеры для каждого проперти
    for _, property in ipairs(properties) do
        if method == nil then
            writeGetter(bufnr, property, existing_getters, last_brace_index, 'getter')
            writeSetter(bufnr, property, existing_setters, last_brace_index, 'setter')
        elseif method == 'getter' then
            writeGetter(bufnr, property, existing_getters, last_brace_index, method)
        elseif method == 'setter' then
            writeSetter(bufnr, property, existing_setters, last_brace_index, method)
        end
    end
end

return M
