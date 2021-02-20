local M = {}

function M.init(opts)
    function M.picker(...)
        local pickers = require('sqls.pickers')
        return (pickers[opts.picker] or pickers.default)(...)
    end
end

return M
