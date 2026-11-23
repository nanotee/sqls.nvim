local M = {}

---@class sqls.Config
---@field markdown_output? boolean render tabular query results as a Markdown table

---Optional; equivalent to setting `vim.g.sqls_nvim`. Lets plugin managers that call `setup()` (e.g. lazy.nvim's `opts`) configure the plugin.
---@param opts? sqls.Config
function M.setup(opts)
    local current = vim.g.sqls_nvim
    vim.g.sqls_nvim = vim.tbl_extend('force', type(current) == 'table' and current or {}, opts or {})
end

return M
