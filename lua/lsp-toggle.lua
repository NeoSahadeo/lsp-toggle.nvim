-- probably make it a bit prettier!
local path = vim.fn.stdpath('cache') .. '/lsp-toggle.json'

local width = vim.api.nvim_win_get_width(0)
local height = vim.api.nvim_win_get_height(0)
local buf = nil
local out = {} -- output table
local tb_all_clients = {}

local function save_session()
	local fh = io.open(path, 'w')
	if fh then
		fh:write(vim.fn.json_encode(tb_all_clients))
		fh:close()
	end
end

local function load_session()
	local fh = io.open(path, 'r')
	if fh then
		local content = fh:read('*a')
		fh:close()
		local data = vim.fn.json_decode(content)

		vim.api.nvim_create_autocmd('LspAttach', {
			callback = function(args)
				for _, tb_server in ipairs(data) do
					if tb_server.enabled then
						pcall(vim.cmd, 'LspStart ' .. tb_server.server_name)
					else
						pcall(vim.cmd, 'LspStop ' .. tb_server.server_name)
					end
				end
			end,
		})
	end
end

local function load_all_clients()
	local mason_lspconfig = require('mason-lspconfig')
	for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
		table.insert(tb_all_clients, {
			enabled = false,
			server_name = server,
		})
	end
end

local function write_to_buffer()
	for _, tb_server in ipairs(tb_all_clients) do
		table.insert(out, (tb_server.enabled and '[x] ' or '[ ] ') .. tb_server.server_name)
	end

	local safe_fn = vim.schedule_wrap(function()
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
	end)
	safe_fn()

	save_session()
end

local function handle_toggle()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local cursor_line = cursor_pos[1]
	local line_text = vim.api.nvim_buf_get_lines(0, cursor_line - 1, cursor_line, false)[1]

	local server_name = string.sub(line_text, 5)
	for index, tb_server in ipairs(tb_all_clients) do
		if tb_server.server_name == server_name then
			tb_all_clients[index].enabled = not tb_all_clients[index].enabled

			if tb_all_clients[index].enabled then
				vim.cmd('LspStart ' .. server_name)
			else
				vim.cmd('LspStop ' .. server_name)
				-- local active_clients = vim.lsp.get_clients()
				-- for _, a_client in ipairs(active_clients) do
				-- 	if a_client.name == server_name then
				-- 		vim.lsp.stop_client(a_client.id)
				-- 	end
				-- end
			end
		end
	end
	out = {}
	write_to_buffer()
end

local function open_window()
	-- clear buffers
	out = {}
	tb_all_clients = {}
	buf = nil

	load_all_clients()

	local active_clients = vim.lsp.get_clients()
	for index, tb_server in ipairs(tb_all_clients) do
		for _, a_client in ipairs(active_clients) do
			if tb_server.server_name == a_client.name then
				tb_all_clients[index].enabled = true
			end
		end
	end

	write_to_buffer()

	local dynamic_height = #tb_all_clients
	if #out > 20 then
		dynamic_height = 20
	end

	local f_width = 30
	local f_height = dynamic_height
	buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)

	local id = vim.api.nvim_open_win(buf, true, {
		title = 'Toggle LSP',
		title_pos = 'center',
		relative = 'editor',
		width = f_width,
		height = f_height,
		border = { '╔', '-', '╗', '║', '╝', '═', '╚', '║' },
		col = (width / 2) - (f_width / 2),
		row = (height / 2) - (f_height / 2),
		style = 'minimal',
	})

	return id
end

local function close_window(id)
	vim.api.nvim_win_close(id, true)
end

local function register_keybinds()
	vim.keymap.set('n', '<CR>', handle_toggle)
end

local function unregister_keybinds()
	vim.keymap.del('n', '<CR>')
end

local function setup()
	local window_id = nil
	local is_open = false

	load_session()

	vim.api.nvim_create_user_command('ToggleLSP', function()
		if is_open then
			is_open = false
			unregister_keybinds()
			close_window(window_id)
		else
			is_open = true
			register_keybinds()
			window_id = open_window()
		end
	end, { desc = 'Toggle the window to display active lsps' })

	vim.api.nvim_create_user_command('ToggleLSPClearCache', function()
		print(path)
		os.remove(path)
		print('Cleared cache, you should probably restart nvim')
	end, { desc = 'Clear the local cache for lsp-toggle' })
end

return { setup = setup }
