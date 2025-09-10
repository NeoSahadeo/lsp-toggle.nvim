-- the main toggle function
local file = require('lsp-toggle.fileutils')
local window = require('lsp-toggle.window')
local utils = require('lsp-toggle.utils')

local M = {}

function M.handle_toggle()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local cursor_line = cursor_pos[1]
	local line_text = vim.api.nvim_buf_get_lines(0, cursor_line - 1, cursor_line, false)[1]

	local server_name = line_text:sub(5)
	for name, tb_server in pairs(utils.clients) do
		if tb_server.server_name == server_name then
			utils.clients[name].enabled = not utils.clients[name].enabled
			local enabled = utils.clients[name].enabled
			vim.lsp.enable(server_name, enabled)
		end
	end
	-- vim.cmd.LspRestart() -- force restart

	window.print_display(utils.clients)
	file.save(utils.clients)
end

return M
