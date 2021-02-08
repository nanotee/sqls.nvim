local api = vim.api

local user_options = require('sqls.user_options')

local M = {}

local function show_results_handler(mods)
    return function(err, _, result, _, _, _, _)
        assert(not err, err and err.message)
        local bufnr = api.nvim_create_buf(false, true)
        api.nvim_buf_set_lines(bufnr, 0, 1, false, vim.split(result, '\n'))
        vim.cmd(('%s split'):format(mods or ''))
        api.nvim_win_set_buf(0, bufnr)
        api.nvim_win_set_option(0, 'wrap', false)
    end
end

local function make_command_executor(command)
    return function(mods, range_given)
        vim.lsp.buf_request(
            0,
            'workspace/executeCommand',
            {
                command = command,
                arguments = {vim.uri_from_bufnr(0)},
                range = range_given and vim.lsp.util.make_given_range_params().range or nil,
            },
            show_results_handler(mods)
            )
    end
end

M.execute_query = make_command_executor('executeQuery')
M.show_databases = make_command_executor('showDatabases')
M.show_schemas = make_command_executor('showSchemas')
M.show_connections = make_command_executor('showConnections')
M.show_tables = make_command_executor('showTables')
M.describe_table = make_command_executor('describeTable')

local function choice_handler(switch_function, answer_formatter)
    return function(err, _, result, _, _, _, _)
        assert(not err, err and err.message)
        local choices = vim.split(result, '\n')
        local function switch_callback(answer)
            return switch_function(answer_formatter(answer))
        end
        user_options.picker(switch_callback, choices)
    end
end

local function make_switch_function(command)
    return function(query)
        vim.lsp.buf_request(
            0,
            'workspace/executeCommand',
            {
                command = command,
                arguments = {query},
            },
            function(err, _, _, _, _, _)
                assert(not err, err and err.message)
            end
            )
    end
end

local function make_prompt_function(command, answer_formatter)
    return function(switch_function)
        vim.lsp.buf_request(
            0,
            'workspace/executeCommand',
            {
                command = command,
            },
            choice_handler(switch_function, answer_formatter)
            )
    end
end

local function format_database_answer(answer) return answer end
local function format_connection_answer(answer) return vim.split(answer, ' ')[1] end

local database_switch_function = make_switch_function('switchDatabase')
local connection_switch_function = make_switch_function('switchConnections')
local database_prompt_function = make_prompt_function('showDatabases', format_database_answer)
local connection_prompt_function = make_prompt_function('showConnections', format_connection_answer)

local function make_switcher(prompt_function, switch_function)
    return function(query)
        if not query then
            prompt_function(switch_function)
            return
        end
        switch_function(query)
    end
end

M.switch_database = make_switcher(database_prompt_function, database_switch_function)
M.switch_connection = make_switcher(connection_prompt_function, connection_switch_function)

return M
