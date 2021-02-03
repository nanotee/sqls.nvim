local M = {}

local pickers = require('sqls.pickers')

function M.init(opts)
    if opts.picker == 'fzf' then
        M.picker = pickers.fzf
    elseif opts.picker == 'telescope' then
        M.picker = pickers.telescope
    else
        M.picker = pickers.default
    end
end

return M
