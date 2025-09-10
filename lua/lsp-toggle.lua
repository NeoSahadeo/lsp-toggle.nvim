local config = require('lsp-toggle.config')

---@class LspToggle
local M = {}

---@param opts? LspToggle.Opts
function M.setup(opts)
	config.setup(opts or {})
end

return M
