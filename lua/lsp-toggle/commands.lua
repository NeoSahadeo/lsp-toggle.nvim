local fileutils = require('lsp-toggle.fileutils')
local window = require('lsp-toggle.window')

local M = {}
M.is_open = false

function M.register_commands()
	vim.api.nvim_create_user_command('ToggleLSP', function()
		-- toggle the window
		-- make sure LSP attaches the buffer
		if M.is_open then
			M.is_open = false
			window.close_window()
			return
		end

		M.is_open = true
		window.open_window()
	end, { desc = 'Toggle the window to display active lsps' })

	vim.api.nvim_create_user_command('ToggleLSPClearCache', function()
		vim.fn.delete(fileutils.root_dir, 'rf')
		vim.notify('Cleared cache, you should probably restart nvim', vim.log.levels.INFO)
	end, { desc = 'Clear the local cache for lsp-toggle' })
end

return M
