local commands = require('lsp-toggle.commands')
local window = require('lsp-toggle.window')

local M = {}

function M.setup()
	local augroup = vim.api.nvim_create_augroup('lsp-toggle', { clear = false })
	vim.api.nvim_create_autocmd('BufLeave', {
		group = augroup,
		callback = function()
			window.close_window()
		end,
	})

	commands.register_commands()
end

return M
