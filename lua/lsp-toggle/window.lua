local utils = require('lsp-toggle.utils')

local M = {}

M.out_buf_table = {}

function M.clear()
	M.out_buf_table = {}
	M.print_display({})
end

---@param clients table<string, ToggleClient>
function M.print_display(clients)
	---@type string[]
	M.out_buf_table = {}

	for name, client in pairs(clients) do
		table.insert(M.out_buf_table, (client.enabled and '[x] ' or '[ ] ') .. name)
	end

	local safe_fn = vim.schedule_wrap(function()
		vim.bo.modifiable = true
		vim.api.nvim_buf_set_lines(M.window_buf, 0, -1, false, M.out_buf_table)
		vim.bo.modifiable = false
	end)
	safe_fn()
end

function M.open_window()
	utils.load_all_clients()
	local f_height = 0

	for _, _ in ipairs(vim.tbl_keys(utils.clients)) do
		f_height = f_height + 1
	end

	local height = vim.o.lines
	local width = vim.o.columns
	local f_width = 30
	if #M.out_buf_table > 20 then
		f_height = 20
	end

	M.win_stats = {
		height = height,
		width = width,
		f_width = f_width,
		f_height = f_height,
	}

	M.window_buf = vim.api.nvim_create_buf(false, true)
	M.print_display(utils.clients)

	M.window_id = vim.api.nvim_open_win(M.window_buf, true, {
		title = 'Toggle LSP',
		title_pos = 'center',
		relative = 'editor',
		width = f_width,
		height = f_height ~= 0 and f_height or 1,
		border = { '╔', '-', '╗', '║', '╝', '═', '╚', '║' },
		col = math.floor((width / 2) - (f_width / 2)),
		row = math.floor((height / 2) - (f_height / 2)),
		style = 'minimal',
	})

	local keymap_opts = { buffer = M.window_buf, noremap = true, silent = true }

	vim.keymap.set('n', 'q', '<CMD>q!<CR>', keymap_opts)
	vim.keymap.set('n', '<Esc>', '<CMD>q!<CR>', keymap_opts)
end

function M.close_window()
	if M.window_id then
		pcall(vim.api.nvim_win_close, M.window_id, true)
	end
end

return M
