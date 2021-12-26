local M = {}

if vim.ui and vim.ui.select then
    function M.default(switch_callback, choices)
        vim.ui.select(choices, {prompt = 'sqls.nvim'}, switch_callback)
    end
else
    function M.default(switch_callback, choices)
        local answer = vim.fn.inputlist(choices)
        if not choices[answer] then return end
        switch_callback(choices[answer])
    end
end

function M.fzf(switch_callback, choices)
    if vim.g.loaded_fzf ~= 1 then
        vim.notify('sqls: The fzf.vim plugin is not installed', vim.lsp.log_levels.WARN)
        return
    end

    local fzf_wrapped_options = vim.fn['fzf#wrap']('sqls', {
            source = choices,
            options = {'--prompt=sqls.nvim>'}
        })
    fzf_wrapped_options['sink*'] = function(answer)
        switch_callback(answer[2])
    end

    vim.fn['fzf#run'](fzf_wrapped_options)
end

function M.telescope(switch_callback, choices)
    local telescope_loaded, _ = pcall(require, 'telescope')
    if not telescope_loaded then
        vim.notify('sqls: The telescope.nvim plugin is not installed', vim.lsp.log_levels.WARN)
        return
    end
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')
    local conf = require('telescope.config').values
    pickers.new({}, {
            prompt_title = 'sqls.nvim',
            finder = finders.new_table {
                results = choices,
            },
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    switch_callback(selection.value)
                end)

                return true
            end,
        }):find()
end

return M
