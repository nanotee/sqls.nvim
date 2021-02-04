local M = {}

function M.default(switch_function, answer_formatter, choices)
    local answer = vim.fn.inputlist(choices)
    if not choices[answer] then return end
    switch_function(answer_formatter(choices[answer]))
end

function M.fzf(switch_function, answer_formatter, choices)
    assert(vim.g.loaded_fzf == 1, 'The fzf.vim plugin must be installed')

    local fzf_wrapped_options = vim.fn['fzf#wrap']('sqls', {
            source = choices,
            options = {'--prompt=sqls.nvim>'}
        })
    fzf_wrapped_options['sink*'] = function(answer)
        switch_function(answer_formatter(answer[2]))
    end

    vim.fn['fzf#run'](fzf_wrapped_options)
end

function M.telescope(switch_function, answer_formatter, choices)
    local telescope_loaded, _ = pcall(require, 'telescope')
    assert(telescope_loaded, 'The telescope.nvim plugin must be installed')
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local actions = require('telescope.actions')
    local conf = require('telescope.config').values
    pickers.new({}, {
            prompt_title = 'sqls.nvim',
            finder = finders.new_table {
                results = choices,
            },
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr)
                actions.goto_file_selection_edit:replace(function()
                    local selection = actions.get_selected_entry()
                    actions.close(prompt_bufnr)
                    switch_function(answer_formatter(selection.value))
                end)

                return true
            end,
        }):find()
end

return M
