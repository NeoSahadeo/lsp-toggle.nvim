local window = require('lsp-toggle.window')

local M = {}

function M.setup()
    local augroup = vim.api.nvim_create_augroup('lsp-toggle', { clear = true })
    vim.api.nvim_create_autocmd('BufLeave', {
        group = augroup,
        callback = function()
            if window.window_id then
                window.toggle_window()
            end
        end,
    })
end

return M
