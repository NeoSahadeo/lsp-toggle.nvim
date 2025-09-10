local fileutils = require('lsp-toggle.fileutils')

local M = {}

---@type table<string, { enabled: boolean, server_name: string }>
M.clients = {}

function M.load_all_clients()
	local clients = vim.lsp.get_clients()

	for _, client in ipairs(clients) do
		M.clients[client.name] = {
			enabled = vim.lsp.is_enabled(client.name),
			server_name = client.name,
		}
	end
end

function M.merge_table_pf()
	M.load_all_clients()
	local file_clients = fileutils.load() or {} -- LSPAttach should set file path

	-- merge tables with priority to file
	for name, client in pairs(M.clients) do
		local added = false
		for fname, fclient in pairs(file_clients) do
			if fclient.server_name == client.server_name then
				M.clients[fname] = fclient
				added = true
			end
		end
		if not added then
			M.clients[name] = client
		end
	end
end

return M
