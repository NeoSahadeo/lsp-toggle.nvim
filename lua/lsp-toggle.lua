local config = require('lsp-toggle.config')

---@class LspToggle
local M = {}

---@param opts? LspToggle.Opts
function M.setup(opts)
	config.setup(opts or {})
end

return M

-- vim:ts=4:sts=4:sw=0:noet:ai:si:sta:
