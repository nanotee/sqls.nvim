local user_options = require('sqls.user_options')
return {
    setup = function(opts)
        user_options.init(opts or {})

        vim.cmd [[command! -buffer -range SqlsExecuteQuery lua require'sqls.commands'.execute_query('<mods>', <range> ~= 0)]]
        vim.cmd [[command! -buffer SqlsShowDatabases lua require'sqls.commands'.show_databases('<mods>')]]
        vim.cmd [[command! -buffer SqlsShowSchemas lua require'sqls.commands'.show_schemas('<mods>')]]
        vim.cmd [[command! -buffer SqlsShowConnections lua require'sqls.commands'.show_connections('<mods>')]]
        -- Not yet supported by the language server:
        -- vim.cmd [[command! -buffer SqlsShowTables lua require'sqls.commands'.show_tables('<mods>')]]
        -- vim.cmd [[command! -buffer SqlsDescribeTable lua require'sqls.commands'.describe_table('<mods>')]]
        vim.cmd [[command! -buffer -nargs=? SqlsSwitchDatabase lua require'sqls.commands'.switch_database(<f-args>)]]
        vim.cmd [[command! -buffer -nargs=? SqlsSwitchConnection lua require'sqls.commands'.switch_connection(<f-args>)]]
    end
}
