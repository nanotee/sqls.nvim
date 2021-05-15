local M = {}

M._user_options = {}

M.setup = function(opts)
    function M._user_options.picker(...)
        local pickers = require('sqls.pickers')
        return (pickers[opts.picker] or pickers.default)(...)
    end

    vim.cmd [[command! -buffer -range SqlsExecuteQuery lua require'sqls.commands'.execute_query('<mods>', <range> ~= 0)]]
    vim.cmd [[command! -buffer -range SqlsExecuteQueryVertical lua require'sqls.commands'.execute_query('<mods>', <range> ~= 0, '-show-vertical')]]
    vim.cmd [[command! -buffer SqlsShowDatabases lua require'sqls.commands'.show_databases('<mods>')]]
    vim.cmd [[command! -buffer SqlsShowSchemas lua require'sqls.commands'.show_schemas('<mods>')]]
    vim.cmd [[command! -buffer SqlsShowConnections lua require'sqls.commands'.show_connections('<mods>')]]
    -- Not yet supported by the language server:
    -- vim.cmd [[command! -buffer SqlsShowTables lua require'sqls.commands'.show_tables('<mods>')]]
    -- vim.cmd [[command! -buffer SqlsDescribeTable lua require'sqls.commands'.describe_table('<mods>')]]
    vim.cmd [[command! -buffer -nargs=? SqlsSwitchDatabase lua require'sqls.commands'.switch_database(<f-args>)]]
    vim.cmd [[command! -buffer -nargs=? SqlsSwitchConnection lua require'sqls.commands'.switch_connection(<f-args>)]]
end

return M
