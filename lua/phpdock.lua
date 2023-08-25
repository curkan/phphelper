function add_php_docblock()
    local lnum = vim.fn.line('.')
    local indent = vim.fn.indent(lnum)
    local func_name = vim.fn.matchstr(vim.fn.getline(lnum), 'public function \\(\\w\\+\\)')
    if func_name ~= '' then
        local docblock = {
            string.rep(" ", indent) .. "/**",
            string.rep(" ", indent) .. " * Description of " .. func_name,
            string.rep(" ", indent) .. " *",
            string.rep(" ", indent) .. " * @param Response $response",
            string.rep(" ", indent) .. " * @return array",
            string.rep(" ", indent) .. " */"
        }
        vim.api.nvim_buf_set_lines(0, lnum - 1, lnum - 1, false, docblock)
    end
end

vim.cmd("command! AddPhpDocblock lua add_php_docblock()")
