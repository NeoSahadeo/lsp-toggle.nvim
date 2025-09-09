local fileutils = require('lsp-toggle.fileutils')

local M = {}

---@type { enabled: boolean, server_name: string }[]
M.clients = {}

function M.load_all_clients()
	---@type { enabled: boolean, server_name: string }[]
	local p = {}
	local clients = vim.lsp.get_clients()

	for _, client in ipairs(clients) do
		table.insert(p, {
			enabled = vim.lsp.is_enabled(client.name),
			server_name = client.name,
		})
	end
	return p
end

function M.merge_table_pf()
	local all_clients = M.load_all_clients()
	local file_clients = fileutils.load() or {} -- LSPAttach should set file path

	---@type { enabled: boolean, server_name: string }[]
	local clients = {}

	-- merge tables with priority to file
	for _, c in ipairs(all_clients) do
		local added = false
		for _, fc in ipairs(file_clients) do
			if fc.server_name == c.server_name then
				table.insert(clients, fc)
				added = true
			end
		end
		if not added then
			table.insert(clients, c)
		end
	end

	M.clients = clients
end

return M
