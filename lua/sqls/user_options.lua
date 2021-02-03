local M = {}


function M.init(opts)
    function M.picker(...)
        local pickers = require('sqls.pickers')
        if pickers[opts.picker] then
            return pickers[opts.picker](...)
        end
        return pickers.default(...)
    end
end

return M
