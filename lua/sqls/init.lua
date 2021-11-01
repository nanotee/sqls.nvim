local M = {}

M._user_options = {}

M.setup = function(opts)
    function M._user_options.picker(...)
        local pickers = require('sqls.pickers')
        return (pickers[opts.picker] or pickers.default)(...)
    end

    vim.cmd [[command! -buffer -range SqlsExecuteQuery lua require'sqls.commands'.exec('executeQuery', '<mods>', <range> ~= 0, nil, <line1>, <line2>)]]
    vim.cmd [[command! -buffer -range SqlsExecuteQueryVertical lua require'sqls.commands'.exec('executeQuery', '<mods>', <range> ~= 0, '-show-vertical', <line1>, <line2>)]]
    vim.cmd [[command! -buffer SqlsShowDatabases lua require'sqls.commands'.exec('showDatabases', '<mods>')]]
    vim.cmd [[command! -buffer SqlsShowSchemas lua require'sqls.commands'.exec('showSchemas', '<mods>')]]
    vim.cmd [[command! -buffer SqlsShowConnections lua require'sqls.commands'.exec('showConnections', '<mods>')]]
    -- Not yet supported by the language server:
    -- vim.cmd [[command! -buffer SqlsShowTables lua require'sqls.commands'.exec('showTables', '<mods>')]]
    -- vim.cmd [[command! -buffer SqlsDescribeTable lua require'sqls.commands'.exec('describeTable', '<mods>')]]
    vim.cmd [[command! -buffer -nargs=? SqlsSwitchDatabase lua require'sqls.commands'.switch_database(<f-args>)]]
    vim.cmd [[command! -buffer -nargs=? SqlsSwitchConnection lua require'sqls.commands'.switch_connection(<f-args>)]]

    vim.api.nvim_buf_set_keymap(0, 'n', '<Plug>(sqls-execute-query)', "<Cmd>set opfunc=v:lua.require'sqls.commands'.query<CR>g@", {silent = true})
    vim.api.nvim_buf_set_keymap(0, 'x', '<Plug>(sqls-execute-query)', "<Cmd>set opfunc=v:lua.require'sqls.commands'.query<CR>g@", {silent = true})
    vim.api.nvim_buf_set_keymap(0, 'n', '<Plug>(sqls-execute-query-vertical)', "<Cmd>set opfunc=v:lua.require'sqls.commands'.query_vertical<CR>g@", {silent = true})
    vim.api.nvim_buf_set_keymap(0, 'x', '<Plug>(sqls-execute-query-vertical)', "<Cmd>set opfunc=v:lua.require'sqls.commands'.query_vertical<CR>g@", {silent = true})

end

M.commands = {
    executeQuery = function(code_action, command)
        require('sqls.commands').exec('executeQuery')
    end,
    showDatabases = function(code_action, command)
        require('sqls.commands').exec('showDatabases')
    end,
    showSchemas = function(code_action, command)
        require('sqls.commands').exec('showSchemas')
    end,
    showConnections = function(code_action, command)
        require('sqls.commands').exec('showConnections')
    end,
    showTables = function(code_action, command)
        require('sqls.commands').exec('showTables')
    end,
    describeTable = function(code_action, command)
        require('sqls.commands').exec('describeTable')
    end,
    switchConnections = function(code_action, command)
        require('sqls.commands').switch_connection()
    end,
    switchDatabase = function(code_action, command)
        require('sqls.commands').switch_database()
    end,
}

return M
