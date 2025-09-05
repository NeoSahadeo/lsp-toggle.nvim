-- the main toggle function
local file = require('fileutils')
local window = require('window')
local utils = require('utils')

local M = {}

function M.handle_toggle()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local cursor_line = cursor_pos[1]
	local line_text = vim.api.nvim_buf_get_lines(0, cursor_line - 1, cursor_line, false)[1]

	local server_name = string.sub(line_text, 5)
	for index, tb_server in ipairs(utils.clients) do
		if tb_server.server_name == server_name then
			utils.clients[index].enabled = not utils.clients[index].enabled

			if utils.clients[index].enabled then
				vim.cmd('LspStart ' .. server_name)
			else
				vim.cmd('LspStop ' .. server_name)
			end
		end
	end
	vim.cmd('LspRestart') -- force restart

	window.print_display(utils.clients)
	file.save(utils.clients)
end

function M.toggle_onload()
	-- breaks on spam, fix sometime
	-- print(file.file_path)
	-- vim.cmd('LspStop', vim.lsp.get_clients()) -- force stop
	for _, c in ipairs(utils.clients) do
		if c.enabled then
			pcall(vim.cmd, 'LspStart ' .. c.server_name)
		else
			pcall(vim.cmd, 'LspStop ' .. c.server_name)
		end
	end
	-- vim.cmd('LspRestart') -- force restart
end

return M
