---@module 'vim.lsp'

local M = {}
M.clients = {}

---@class ToggleClient
---@field enabled boolean
---@field config vim.lsp.ClientConfig
---@field id integer

function M.load_all_clients()
	local active_clients = vim.lsp.get_clients()

	if vim.tbl_isempty(active_clients) then
		return
	end

	for _, client in ipairs(active_clients) do
		M.clients[client.name] = {
			enabled = client.initialized,
			config = vim.deepcopy(client.config),
			id = client.id,
		}
	end
end

return M
