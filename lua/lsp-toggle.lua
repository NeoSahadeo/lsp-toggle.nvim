local commands = require('lsp-toggle.commands')
local window = require('lsp-toggle.window')

local M = {}

function M.setup()
	vim.api.nvim_create_autocmd('BufLeave', {
		callback = function()
			window.close_window()
		end,
	})

	commands.register_commands()
end

return M
