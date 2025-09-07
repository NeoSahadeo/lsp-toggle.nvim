local fileutils = require('lsp-toggle.fileutils')
local toggle = require('lsp-toggle.toggle')
local window = require('lsp-toggle.window')

local M = {
	is_open = false,
}

local function register_keybinds()
	vim.keymap.set('n', '<CR>', toggle.handle_toggle)
end

local function unregister_keybinds()
	vim.keymap.del('n', '<CR>')
end

function M.register_commands()
	vim.api.nvim_create_user_command('ToggleLSP', function()
		-- toggle the window
		-- make sure LSP attaches the buffer
		if M.is_open then
			M.is_open = false
			unregister_keybinds()
			window.close_window()
		else
			M.is_open = true
			register_keybinds()
			window.open_window()
		end
	end, { desc = 'Toggle the window to display active lsps' })

	vim.api.nvim_create_user_command('ToggleLSPClearCache', function()
		vim.fn.delete(fileutils.root_dir, 'rf')
		print('Cleared cache, you should probably restart nvim')
	end, { desc = 'Clear the local cache for lsp-toggle' })
end

return M
