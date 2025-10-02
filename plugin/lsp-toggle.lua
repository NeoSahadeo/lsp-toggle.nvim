local fileutils = require('lsp-toggle.fileutils')
local window = require('lsp-toggle.window')

--- TODO: Add command with caching to dynamically
--- switch between file-name caching and file-type caching

vim.api.nvim_create_user_command('ToggleLSP', function(ctx)
	local close = ctx.bang ~= nil and ctx.bang or false

	if close then
		window.close_window()
		return
	end

	window.open_window()
end, {
	desc = 'Toggle the window to display active lsps',
	bang = true,
})

vim.api.nvim_create_user_command('ToggleLSPClearCache', function()
	fileutils.clear_cache()
	vim.notify('Cleared cache, you should probably restart nvim', vim.log.levels.WARN)
end, { desc = 'Clear the local cache for lsp-toggle' })
