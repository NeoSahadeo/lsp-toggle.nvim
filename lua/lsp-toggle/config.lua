local fileutils = require('lsp-toggle.fileutils')
local window = require('lsp-toggle.window')
local utils = require('lsp-toggle.utils')

---@class LspToggle.Opts
local defaults = {
	--- If less than `1`, this will revert back to `20`
	max_height = 20,

	--- If less than `1`, this will revert back to `30`
	max_width = 30,

	--- A list of LSP server names to exclude,
	--- e.g. `{ 'lua_ls', 'clangd' }` and so on...
	---@type string[]
	exclude_lsp = {},

	---@type string[]|'double'|'none'|'rounded'|'shadow'|'single'|'solid'
	border = { '╔', '-', '╗', '║', '╝', '═', '╚', '║' },

	-- Enable/Disable caching
	cache = true,
}

---@class LspToggleConfig
local M = {}

---@type LspToggle.Opts
M.options = {}

---@param opts? LspToggle.Opts
function M.setup(opts)
	if vim.fn.has('nvim-0.11') == 1 then
		vim.validate('opts', opts, 'table', true, 'LspToggle.Opts?')
	else
		vim.validate({ opts = { opts, { 'table', 'nil' } } })
	end
	opts = opts or {}

	M.options = vim.tbl_deep_extend('keep', opts, defaults)

	if M.options.max_height <= 0 then
		M.options.max_height = defaults.max_height
	end

	if M.options.max_width <= 0 then
		M.options.max_width = defaults.max_width
	end

	M.setup_autocmds()
end

function M.setup_autocmds()
	local load_cache = function()
		local opts = require('lsp-toggle.config').options
		if not opts.cache then
			return
		end
		utils.merge_table_pf() -- merge saved data before enabling/disabling clients
		for _, tb_server in pairs(utils.clients) do
			vim.lsp.enable(tb_server.server_name, tb_server.enabled)
		end
	end

	local augroup = vim.api.nvim_create_augroup('lsp-toggle', { clear = false })

	vim.api.nvim_create_autocmd('LspAttach', {
		group = augroup,
		callback = function()
			if vim.bo.buftype ~= '' then
				return
			end

			fileutils.set_file_path(vim.api.nvim_buf_get_name(0))
			load_cache()
		end,
	})

	vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
		callback = function(args)
			if vim.bo[args.buf].buftype ~= '' then
				return
			end

			fileutils.set_file_path(vim.api.nvim_buf_get_name(args.buf))
			load_cache()
		end,
	})

	vim.api.nvim_create_autocmd('BufLeave', {
		group = augroup,
		callback = function()
			window.close_window()
		end,
	})
end

return M

-- vim:ts=4:sts=4:sw=0:noet:ai:si:sta:
