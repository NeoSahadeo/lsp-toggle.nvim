local utils = require('lsp-toggle.utils')

local width = vim.api.nvim_win_get_width(0)
local height = vim.api.nvim_win_get_height(0)

local M = {}
M.out_buf_table = {}

function M.clear()
	M.out_buf_table = {}
	M.print_display({})
end

function M.print_display(clients)
	M.out_buf_table = {}
	for _, tb_server in ipairs(clients) do
		table.insert(
			M.out_buf_table,
			(tb_server.enabled and '[x] ' or '[ ] ') .. tb_server.server_name
		)
	end

	local safe_fn = vim.schedule_wrap(function()
		vim.api.nvim_buf_set_lines(M.window_buf, 0, -1, false, M.out_buf_table)
	end)
	safe_fn()
end

function M.open_window()
	utils.merge_table_pf()

	local dynamic_height = #utils.clients
	if #M.out_buf_table > 20 then
		dynamic_height = 20
	end

	local f_width = 30
	local f_height = dynamic_height
	M.window_buf = vim.api.nvim_create_buf(false, true)
	M.print_display(utils.clients)

	M.window_id = vim.api.nvim_open_win(M.window_buf, true, {
		title = 'Toggle LSP',
		title_pos = 'center',
		relative = 'editor',
		width = f_width,
		height = f_height,
		border = { '╔', '-', '╗', '║', '╝', '═', '╚', '║' },
		col = math.floor((width - f_width) / 2),
		row = math.floor((height - f_height) / 2),
		style = 'minimal',
	})

	local map_opts = { buffer = M.window_buf, noremap = true, silent = true }
	vim.keymap.set('n', 'q', M.close_window, map_opts)
	vim.keymap.set('n', '<Esc>', M.close_window, map_opts)
	vim.keymap.set('n', '<CR>', require('lsp-toggle.toggle').handle_toggle, map_opts)
end

function M.close_window()
	if M.window_id then
		pcall(vim.api.nvim_win_close, M.window_id, true)
	end
end

return M
