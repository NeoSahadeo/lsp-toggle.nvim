local utils = require('lsp-toggle.utils')

local M = {}

function M.parse_then_toggle()
    utils.load_all_clients()

	local cursor_pos = vim.api.nvim_win_get_cursor(M.window_id)
	local cursor_line = cursor_pos[1]
	local line_text =
		vim.api.nvim_buf_get_lines(M.window_buf, cursor_line - 1, cursor_line, false)[1]

	local server_name = line_text:sub(5)
	for name, client in pairs(utils.clients) do
		if name == server_name then
			local enabled = client.enabled
			vim.lsp.enable(name, not enabled)
			utils.clients[name].enabled = not enabled
		end
	end
end

function M.update_window()
	M.print_display(utils.clients)
	vim.api.nvim_buf_set_lines(M.window_buf, 0, -1, false, M.out_buf_table)
end

---@param clients table<string, ToggleClient>
function M.print_display(clients)
	---@type string[]
	M.out_buf_table = {}

	for name, client in pairs(clients) do
		table.insert(M.out_buf_table, (client.enabled and '[x] ' or '[ ] ') .. name)
	end
end

function M.toggle_window()
	if not M.window_id then
		utils.load_all_clients()
		local f_height = 0
		for _, _ in ipairs(vim.tbl_keys(utils.clients)) do
			f_height = f_height + 1
		end

		M.print_display(utils.clients)

		local f_width = 30
		if #M.out_buf_table > 20 then
			f_height = 20
		end

		M.window_buf = vim.api.nvim_create_buf(false, false)

		M.window_id = vim.api.nvim_open_win(M.window_buf, true, {
			title = 'Toggle LSP',
			title_pos = 'center',
			relative = 'editor',
			width = f_width,
			height = f_height ~= 0 and f_height or 1,
			border = { '╔', '-', '╗', '║', '╝', '═', '╚', '║' },
			col = math.floor((vim.o.columns - f_width) / 2),
			row = math.floor((vim.o.lines - f_height) / 2),
			style = 'minimal',
		})

        vim.api.nvim_set_option_value('swapfile', false, { buf = M.window_buf })
        vim.api.nvim_set_option_value('buftype', 'nofile', { buf = M.window_buf })
        vim.api.nvim_set_option_value('filetype', 'lsp_toggle', { buf = M.window_buf })

		local keymap_opts = { buffer = M.window_buf, noremap = true, silent = true }

		vim.keymap.set('n', 'q', M.toggle_window, keymap_opts)
		vim.keymap.set('n', '<Esc>', M.toggle_window, keymap_opts)
		vim.keymap.set('n', '<CR>', function()
			M.parse_then_toggle()
			M.update_window()
		end, keymap_opts)

		return
	end

	--- If window is opened
	vim.api.nvim_win_close(M.window_id, true)
	M.window_id = nil
end

return M
