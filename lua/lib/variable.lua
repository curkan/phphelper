local variable = {}

function variable.get_variable(line)
    local words = {}

    for word in line:gmatch("%S+") do
        table.insert(words, word)
    end

    local count_words = #words

    local type = nil
    local name = nil

    if count_words == 2 then
        -- public $name
        name = string.match(line, "%s+$(%w+)")
    elseif count_words == 3 then
        -- public static $name
        -- public string $name
        name = string.match(line, "%s+$(%w+)")

        local staticKeyword = string.match(line, "%s*(static)")

        if staticKeyword then
            type = nil
        else
            type = string.match(line, "[public|function|protected]%s+([%w]+)")
        end
    elseif count_words == 4 then
        -- public static string $name
        type = words[3]
        name = string.match(line, "%s+$(%w+)")
    end

    local variables = {
        Type = type,
        Name = name,
    }

    return variables
end

function variable.create(line, indent, lnum, variable_info)
    if next(variable_info) == nil then
        return
    end

    local docblock = {
        string.rep(" ", indent) .. "/**",
    }

    table.insert(docblock, string.rep(" ", indent) .. " * @var "
    .. (variable_info.Type ~= nil and variable_info.Type .. "" or "mixed"))

    table.insert(docblock, string.rep(" ", indent) .. " */")
    vim.api.nvim_buf_set_lines(0, lnum - 1, lnum - 1, false, docblock)
end

return variable
