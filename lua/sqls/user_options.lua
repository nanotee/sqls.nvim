local M = {}

local pickers = require('sqls.pickers')

function M.init(opts)
    if opts.picker == 'fzf' then
        M.picker = pickers.fzf
    else
        M.picker = pickers.default
    end
end

return M
