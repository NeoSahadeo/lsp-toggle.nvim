local fileutils = require('lsp-toggle.fileutils')

local M = {}

---@type table<string, { enabled: boolean, server_name: string }>
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
		else
			M.clients[client.name] = nil
		end
	end
end

function M.merge_table_pf()
	M.load_all_clients()
	local file_clients = fileutils.load() or {} -- LSPAttach should set file path
	local excluded = require('lsp-toggle.config').options.exclude_lsp

	-- merge tables with priority to file
	for name, client in pairs(M.clients) do
		local added = false
		if not vim.tbl_contains(excluded, name) then
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
