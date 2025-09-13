local config = require('lsp-toggle.config')

---@class LspToggle
local M = {}

---@param opts? LspToggle.Opts
function M.setup(opts)
	if vim.fn.has('nvim-0.11') == 1 then
		vim.validate('opts', opts, 'table', true, 'LspToggle.Opts?')
	else
		vim.validate({ opts = { opts, { 'table', 'nil' } } })
	end
	config.setup(opts or {})
end

return M

-- vim:ts=4:sts=4:sw=0:noet:ai:si:sta:
