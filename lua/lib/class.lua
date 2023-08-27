local class = {}

local function get_implements(string)
    local implementString = string.match(string, "implements%s+([%w,]+)")

    if implementString ~= nil then
        local implements = {}
        for type in string.gmatch(implementString, "([%w,]+)") do
            table.insert(implements, type)
        end

        return implements
    end

    return nil
end

function class.get_class(line)
    local class_info = {}
    -- class_info.Name = line:match("class%s+(%w+)%s+extends")
    class_info.Abstract = string.match(line, "abstract%s+(%w+)")
    class_info.Name = string.match(line, "class%s+(%w+)")
    class_info.Extends = string.match(line, "extends%s+(%w+)")

    class_info.Implements = get_implements(line)

    return class_info
end

function class.create(line, indent, lnum, class_info)
    if next(class_info) == nil then
        return
    end

    local docblock = {
        string.rep(" ", indent) .. "/**",
        string.rep(" ", indent) .. " * @package " .. class_info.Name,
        string.rep(" ", indent) .. " * @see " .. class_info.Extends,
    }

    if class_info.Implements ~= nil then
        local class_implements_string = " * @implements " .. table.concat(class_info.Implements, '|')

        table.insert(docblock, string.rep(" ", indent) .. class_implements_string)
    end

    if class_info.Abstract ~=nil then
        table.insert(docblock, string.rep(" ", indent) .. " * @abstract")
    end

    table.insert(docblock, string.rep(" ", indent) .. " */")
    vim.api.nvim_buf_set_lines(0, lnum - 1, lnum - 1, false, docblock)
end

return class
