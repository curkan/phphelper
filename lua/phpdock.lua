local function add_php_docblock()
    local lnum = vim.fn.line('.')
    local indent = vim.fn.indent(lnum)
    local func_name = vim.fn.matchstr(vim.fn.getline(lnum), 'public function \\(\\w\\+\\)')
    if func_name ~= '' then
        local return_type = vim.fn.matchstr(vim.fn.getline(lnum), 'public function \\w+\\(([^)]*)\\): \\([[:alnum:]_]+\\)')
        local docblock = {
            string.rep(" ", indent) .. "/**",
            string.rep(" ", indent) .. " * Description of " .. func_name,
            string.rep(" ", indent) .. " *",
            string.rep(" ", indent) .. " * @param Response $response Description of the response parameter.",
            string.rep(" ", indent) .. " * @return " .. return_type,
            string.rep(" ", indent) .. " */"
        }
        vim.api.nvim_buf_set_lines(0, lnum - 1, lnum - 1, false, docblock)
    end
end

vim.cmd("command! AddPhpDocblock lua add_php_docblock()")
