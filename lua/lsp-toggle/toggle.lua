-- the main toggle function
local window = require('lsp-toggle.window')
local utils = require('lsp-toggle.utils')

local M = {}

function M.handle_toggle()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local cursor_line = cursor_pos[1]
	local line_text = vim.api.nvim_buf_get_lines(0, cursor_line - 1, cursor_line, false)[1]

	local server_name = line_text:sub(5)
	for name, tb_server in pairs(utils.clients) do
		if name == server_name then
			local enabled = not tb_server.enabled
			utils.clients[name].enabled = enabled
			vim.lsp.enable(name, enabled)
		end
	end
	-- vim.cmd('LspRestart') -- force restart

	window.print_display(utils.clients)
end

return M
