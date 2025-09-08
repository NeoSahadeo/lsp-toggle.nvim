local toggle = require('lsp-toggle.toggle')
local window = require('lsp-toggle.window')

local M = {}
M.is_open = false

function M.register_keybinds()
	vim.keymap.set('n', '<CR>', toggle.handle_toggle)
end

function M.unregister_keybinds()
	vim.keymap.del('n', '<CR>')
end

return M
