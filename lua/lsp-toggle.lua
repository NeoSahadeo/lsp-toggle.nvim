local commands = require('lsp-toggle.commands')
local window = require('lsp-toggle.window')
local utils = require('lsp-toggle.utils')
local fileutils = require('lsp-toggle.fileutils')

local M = {}

function M.setup()
	local augroup = vim.api.nvim_create_augroup('lsp-toggle', { clear = false })

	vim.api.nvim_create_autocmd('LspAttach', {
		group = augroup,
		callback = function()
			if vim.bo.buftype ~= '' then
				return
			end

			fileutils.set_file_path(vim.api.nvim_buf_get_name(0))
			utils.merge_table_pf()
		end,
	})

	vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
		callback = function(args)
			if vim.bo[args.buf].buftype ~= '' then
				return
			end

			fileutils.set_file_path(vim.api.nvim_buf_get_name(args.buf))
		end,
	})

	vim.api.nvim_create_autocmd('BufLeave', {
		group = augroup,
		callback = function()
			window.close_window()
		end,
	})

	commands.register_commands()
end

return M
