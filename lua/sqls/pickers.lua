local M = {}

function M.default(switch_function, answer_formatter, choices)
    local answer = vim.fn.inputlist(choices)
    if not choices[answer] then return end
    switch_function(answer_formatter(choices[answer]))
end

function M.fzf(switch_function, answer_formatter, choices)
    local function callback(answer)
        switch_function(answer_formatter(answer))
    end
    vim.fn['sqls_nvim#pickers#fzf'](choices, callback)
end

return M
