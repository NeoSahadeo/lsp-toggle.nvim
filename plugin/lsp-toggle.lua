local fileutils = require('lsp-toggle.fileutils')
local window = require('lsp-toggle.window')

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
	local notify = fileutils.clear_cache()
	if notify then
		vim.notify('Cleared cache, you should probably restart nvim', vim.log.levels.WARN)
	end
end, { desc = 'Clear the local cache for lsp-toggle' })

-- vim:ts=4:sts=4:sw=0:noet:ai:si:sta:
