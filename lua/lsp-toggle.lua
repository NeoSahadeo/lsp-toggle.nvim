local window = require('lsp-toggle.window')
local utils = require('lsp-toggle.utils')

local M = {}

function M.setup()
	local augroup = vim.api.nvim_create_augroup('lsp-toggle', { clear = true })
	vim.api.nvim_create_autocmd('BufLeave', {
		group = augroup,
		callback = function()
			window.close_window()
		end,
	})
end

return M
