local func = {}


local function parse_params(params_str)
    local params = {}
    local pattern = "(%w+)%s+$(%w+)"

    if params_str == nil then
        return params
    end

    local parse = string.gmatch(params_str, pattern)

    if parse ~= nil then
        for type, name in string.gmatch(params_str, pattern) do
            table.insert(params, { type = type, name = name })
        end
    end


    return params
end

local function parse_return_types(string)
    -- Находим возвращаемый тип после двоеточия
    local returnType = string.match(string, ":%s*([%w|]+)")

    if returnType ~= nil then
        -- Разбиваем возвращаемый тип на отдельные типы
        local returnTypes = {}
        for type in string.gmatch(returnType, "([%w|]+)") do
            table.insert(returnTypes, type)
        end

        return returnTypes
    end

    return nil
end

function func.create(line, indent, lnum)
    local params_str = string.match(line, "%((.+)%)")
    local params = parse_params(params_str)
    local return_types = parse_return_types(line)

    local docblock = {
        string.rep(" ", indent) .. "/**",
    }

    for _, param in ipairs(params) do
        table.insert(docblock, string.rep(" ", indent) .. " * @param " .. param.type .. " $" .. param.name)
    end

    -- Добавляем return к комментарию
    if return_types ~= nil then
        local return_types_string = " * @return " .. table.concat(return_types, '|')

        -- Добавляем пустую строчку перед return
        table.insert(docblock, string.rep(" ", indent) .. " *")
        -- Добавляем возвращаемые типы
        table.insert(docblock, string.rep(" ", indent) .. return_types_string )
    end

    table.insert(docblock, string.rep(" ", indent) .. " */")
    vim.api.nvim_buf_set_lines(0, lnum - 1, lnum - 1, false, docblock)
end

function func.get_function(line)
    local func_name = string.match(line, "function%s+([%w_]+)")

    return func_name
end


return func
