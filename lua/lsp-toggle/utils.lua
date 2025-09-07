local fileutils = require('lsp-toggle.fileutils')

local M = {
	clients = {},
}

function M.load_all_clients()
	local p = {}
	local mason_lspconfig = require('mason-lspconfig')
	for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
		table.insert(p, {
			enabled = false,
			server_name = server,
		})
	end

	local active_clients = vim.lsp.get_clients()
	for index, all in ipairs(p) do
		for _, a_client in ipairs(active_clients) do
			if all.server_name == a_client.name then
				p[index].enabled = true
			end
		end
	end
	return p
end

function M.merge_table_pf()
	local all_clients = M.load_all_clients()
	local file_clients = fileutils.load() or {} -- LSPAttach should set file path

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
