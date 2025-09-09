local fileutils = require('lsp-toggle.fileutils')
local commands = require('lsp-toggle.commands')
local window = require('lsp-toggle.window')
local toggle = require('lsp-toggle.toggle')
local utils = require('lsp-toggle.utils')

local M = {}

function M.setup()
	vim.api.nvim_create_autocmd('LspAttach', {
		callback = function(args)
			if vim.bo.buftype == '' then
				fileutils.file_path = vim.api.nvim_buf_get_name(args.buf)

				utils.merge_table_pf()

				for _, c in ipairs(utils.clients) do
					if c.enabled then
						vim.cmd.LspStart(c.server_name)
					else
						vim.cmd.LspStop(c.server_name)
					end
				end
			end
		end,
	})

	vim.api.nvim_create_autocmd('BufEnter', {
		callback = function(args)
			local bufnr = args.buf
			if vim.bo[bufnr].buftype == '' then
				fileutils.file_path = vim.api.nvim_buf_get_name(bufnr)
				toggle.toggle_onload()
			end
		end,
	})

	vim.api.nvim_create_autocmd('BufLeave', {
		callback = function()
			window.close_window()
		end,
	})

	commands.register_commands()
end

return M
