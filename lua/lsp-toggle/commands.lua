local fileutils = require('lsp-toggle.fileutils')
local window = require('lsp-toggle.window')

local M = {}

function M.register_commands()
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
		vim.fn.delete(fileutils.root_dir, 'rf')
		vim.notify('Cleared cache, you should probably restart nvim', vim.log.levels.INFO)
	end, { desc = 'Clear the local cache for lsp-toggle' })
end

return M
