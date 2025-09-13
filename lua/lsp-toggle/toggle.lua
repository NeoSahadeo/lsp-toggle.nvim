-- the main toggle function
local file = require('lsp-toggle.fileutils')
local window = require('lsp-toggle.window')
local utils = require('lsp-toggle.utils')

---@class LspToggle.Toggle
local M = {}

function M.handle_toggle()
	local opts = require('lsp-toggle.config').options
	local win = window.window_id
	local bufnr = window.window_buf

	local cursor_line = vim.api.nvim_win_get_cursor(win)[1]
	local line_text = vim.api.nvim_buf_get_lines(bufnr, cursor_line - 1, cursor_line, false)[1]

	local server_name = line_text:sub(5)
	for name, tb_server in pairs(utils.clients) do
		if tb_server.server_name == server_name then
			utils.clients[name].enabled = not utils.clients[name].enabled
			local enabled = utils.clients[name].enabled
			vim.lsp.enable(server_name, enabled)
		end
	end

	window.print_display(utils.clients)
	if opts.cache then
		file.save(utils.clients)
	end
end

return M

-- vim:ts=4:sts=4:sw=0:noet:ai:si:sta:
