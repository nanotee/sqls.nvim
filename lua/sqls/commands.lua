local api = vim.api
local fn = vim.fn

local user_options = require('sqls')._user_options

local M = {}

local function make_show_results_handler(mods)
    return function(err, result, _, _)
        if err then
            vim.notify('sqls: ' .. err.message, vim.log.levels.ERROR)
            return
        end
        local tempfile = fn.tempname() .. '.sqls_output'
        local bufnr = fn.bufnr(tempfile, true)
        api.nvim_buf_set_lines(bufnr, 0, 1, false, vim.split(result, '\n'))
        vim.cmd(('%s pedit %s'):format(mods or '', tempfile))
        api.nvim_buf_set_option(bufnr, 'filetype', 'sqls_output')
    end
end

function M.exec(command, mods, range_given, show_vertical, line1, line2)
    local range
    if range_given then
        range = vim.lsp.util.make_given_range_params({line1, 0}, {line2, math.huge}).range
        range['end'].character = range['end'].character - 1
    end

    vim.lsp.buf_request(
        0,
        'workspace/executeCommand',
        {
            command = command,
            arguments = {vim.uri_from_bufnr(0), show_vertical},
            range = range,
        },
        make_show_results_handler(mods)
        )
end

local function make_query_mapping(show_vertical)
    return function(type)
        local range
        local _, lnum1, col1, _ = unpack(fn.getpos("'["))
        local _, lnum2, col2, _ = unpack(fn.getpos("']"))
        if type == 'block' then
            vim.notify('sqls does not support block-wise ranges!', vim.log.levels.ERROR)
            return
        elseif type == 'line' then
            range = vim.lsp.util.make_given_range_params({lnum1, 0}, {lnum2, math.huge}).range
            range['end'].character = range['end'].character - 1
        elseif type == 'char' then
            range = vim.lsp.util.make_given_range_params({lnum1, col1 - 1}, {lnum2, col2 - 1}).range
        end

        vim.lsp.buf_request(
            0,
            'workspace/executeCommand',
            {
                command = 'executeQuery',
                arguments = {vim.uri_from_bufnr(0), show_vertical},
                range = range,
            },
            make_show_results_handler('')
            )
    end
end

M.query = make_query_mapping()
M.query_vertical = make_query_mapping('-show-vertical')

local function make_choice_handler(switch_function, answer_formatter)
    return function(err, result, _, _)
        if err then
            vim.notify('sqls: ' .. err.message, vim.log.levels.ERROR)
            return
        end
        if result == '' then
            vim.notify('sqls: No choices available')
            return
        end
        local choices = vim.split(result, '\n')
        local function switch_callback(answer)
            if not answer then return end
            switch_function(answer_formatter(answer))
        end
        user_options.picker(switch_callback, choices)
    end
end

local function switch_handler(err, _, _, _)
    if err then
        vim.notify('sqls: ' .. err.message, vim.log.levels.ERROR)
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
            switch_handler
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
            make_choice_handler(switch_function, answer_formatter)
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
