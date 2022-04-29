local api = vim.api
local fn = vim.fn

local user_options = require('sqls')._user_options

local M = {}

---@alias sqls_lsp_handler fun(err?: table, result?: any, ctx: table, config: table)

---@param mods string
---@return sqls_lsp_handler
local function make_show_results_handler(mods)
    return function(err, result, _, _)
        if err then
            vim.notify('sqls: ' .. err.message, vim.log.levels.ERROR)
            return
        end
        if not result then
            return
        end
        local tempfile = fn.tempname() .. '.sqls_output'
        local bufnr = fn.bufnr(tempfile, true)
        api.nvim_buf_set_lines(bufnr, 0, 1, false, vim.split(result, '\n'))
        vim.cmd(('%s pedit %s'):format(mods or '', tempfile))
        api.nvim_buf_set_option(bufnr, 'filetype', 'sqls_output')
    end
end

---@param command string
---@param mods? string
---@param range_given? boolean
---@param show_vertical? '"-show-vertical"'
---@param line1? integer
---@param line2? integer
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

---@alias sqls_operatorfunc fun(type: '"block"'|'"line"'|'"char"')

---@param show_vertical? '"-show-vertical"'
---@return sqls_operatorfunc
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

---@alias sqls_switch_function fun(query: string)
---@alias sqls_prompt_function fun(switch_function: sqls_switch_function, query?: string)
---@alias sqls_answer_formatter fun(answer: string): string
---@alias sqls_switcher fun(query?: string)

---@param switch_function sqls_switch_function
---@param answer_formatter sqls_answer_formatter
---@param event_name sqls_event_name
---@param query? string
---@return sqls_lsp_handler
local function make_choice_handler(switch_function, answer_formatter, event_name, query)
    return function(err, result, _, _)
        if err then
            vim.notify('sqls: ' .. err.message, vim.log.levels.ERROR)
            return
        end
        if not result then
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
            require('sqls.events')._dispatch_event(event_name, {choice = answer})
        end
        if query then
            local answer = choices[tonumber(query)]
            switch_callback(answer)
            return
        end
        user_options.picker(switch_callback, choices)
    end
end

---@type sqls_lsp_handler
local function switch_handler(err, _, _, _)
    if err then
        vim.notify('sqls: ' .. err.message, vim.log.levels.ERROR)
    end
end

---@param command string
---@return sqls_switch_function
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

---@param command string
---@param answer_formatter sqls_answer_formatter
---@param event_name sqls_event_name
---@return sqls_prompt_function
local function make_prompt_function(command, answer_formatter, event_name)
    return function(switch_function, query)
        vim.lsp.buf_request(
            0,
            'workspace/executeCommand',
            {
                command = command,
            },
            make_choice_handler(switch_function, answer_formatter, event_name, query)
            )
    end
end

---@type sqls_answer_formatter
local function format_database_answer(answer) return answer end
---@type sqls_answer_formatter
local function format_connection_answer(answer) return vim.split(answer, ' ')[1] end

local database_switch_function = make_switch_function('switchDatabase')
local connection_switch_function = make_switch_function('switchConnections')
local database_prompt_function = make_prompt_function('showDatabases', format_database_answer, 'database_choice')
local connection_prompt_function = make_prompt_function('showConnections', format_connection_answer, 'connection_choice')

---@param prompt_function sqls_prompt_function
---@param switch_function sqls_switch_function
---@return sqls_switcher
local function make_switcher(prompt_function, switch_function)
    return function(query)
        prompt_function(switch_function, query)
    end
end

M.switch_database = make_switcher(database_prompt_function, database_switch_function)
M.switch_connection = make_switcher(connection_prompt_function, connection_switch_function)

return M
