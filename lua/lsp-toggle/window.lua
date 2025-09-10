local utils = require('lsp-toggle.utils')

local M = {}
M.out_buf_table = {}

---@param clients table<string, { enabled: boolean, server_name: string }>
function M.print_display(clients)
	M.out_buf_table = {}
	for _, tb_server in pairs(clients) do
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
    if M.window_id then
        return
    end

	utils.merge_table_pf()

    local dynamic_height = 0
    for _, _ in pairs(utils.clients) do
        dynamic_height = dynamic_height + 1
    end

    dynamic_height = dynamic_height > 0 and dynamic_height or 1

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
		col = math.floor((vim.o.columns - f_width) / 2),
		row = math.floor((vim.o.lines - f_height) / 2),
		style = 'minimal',
	})

	local map_opts = { buffer = M.window_buf, noremap = true, silent = true }
	vim.keymap.set('n', 'q', M.close_window, map_opts)
	vim.keymap.set('n', '<Esc>', M.close_window, map_opts)

	--- WARN: Leave the `require('lsp-toggle.toggle')...` as is, or it'll break!
	vim.keymap.set('n', '<CR>', require('lsp-toggle.toggle').handle_toggle, map_opts)
end

function M.close_window()
	if M.window_id then
		vim.api.nvim_win_close(M.window_id, true)
        M.window_id = nil
	end
end

return M
