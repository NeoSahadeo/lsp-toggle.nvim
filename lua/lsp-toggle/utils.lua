---@module 'vim.lsp'

local M = {}

---@class ToggleClient
---@field enabled? boolean
---@field config? vim.lsp.Client
---@field id? integer

---@type table<string, ToggleClient>
M.clients = {}

function M.load_all_clients()
	local active_clients = vim.lsp.get_clients()

	if vim.tbl_isempty(active_clients) then
		return
	end

	for _, client in ipairs(active_clients) do
		M.clients[client.name] = {
			enabled = vim.lsp.is_enabled(client.name),
			config = vim.deepcopy(client),
			id = client.id,
		}
	end
end

function M.drop_unused_clients()
	local dropped = false

	if not M.clients or vim.tbl_isempty(M.clients) then
		return dropped
	end

	for name, client in pairs(M.clients) do
		if not vim.lsp.buf_is_attached(0, client.id) then
			M.clients[name] = nil
			dropped = true
		end
	end

	return dropped
end

return M
