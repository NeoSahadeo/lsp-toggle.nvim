local fileutils = require('lsp-toggle.fileutils')

---@class LspToggleUtils.Client
---@field enabled boolean
---@field server_name string

---@class LspToggleUtils
local M = {}

---@type table<string, LspToggleUtils.Client>
M.clients = {}

function M.load_all_clients()
	local clients = vim.lsp.get_clients()
	local excluded = require('lsp-toggle.config').options.exclude_lsp

	for _, client in ipairs(clients) do
		if not vim.tbl_contains(excluded, client.name) then
			M.clients[client.name] = {
				enabled = vim.lsp.is_enabled(client.name),
				server_name = client.name,
			}
		elseif vim.list_contains(vim.tbl_keys(M.clients), client.name) then
			M.clients[client.name] = nil
		end
	end
end

function M.merge_table_pf()
	local opts = require('lsp-toggle.config').options

	M.load_all_clients()
	local file_clients = opts.cache and (fileutils.load() or {}) or {}
	local excluded = require('lsp-toggle.config').options.exclude_lsp

	-- merge tables with priority to file
	for name, client in pairs(M.clients) do
		local added = false
		if not vim.list_contains(excluded, name) then
			for fname, fclient in pairs(file_clients) do
				if fname == name then
					M.clients[fname] = fclient
					added = true
				end
			end
			if not added then
				M.clients[name] = client
			end
		end
	end
end

return M

-- vim:ts=4:sts=4:sw=0:noet:ai:si:sta:
