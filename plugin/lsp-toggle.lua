vim.api.nvim_create_user_command('ToggleLSP', function()
	local commands = require('lsp-toggle.commands')
	local window = require('lsp-toggle.window')
	-- toggle the window
	-- make sure LSP attaches the buffer
	if commands.is_open then
		commands.is_open = false
		commands.unregister_keybinds()
		window.close_window()
	else
		commands.is_open = true
		commands.register_keybinds()
		window.open_window()
	end
end, { desc = 'Toggle the window to display active lsps' })
