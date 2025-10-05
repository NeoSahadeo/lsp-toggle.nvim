---@class lsp_toggle.tb_server
---@field enabled boolean
---@field server_name string
---@field is_attached fun(): boolean

local fileutils = require('lsp-toggle.fileutils')

local M = {}

---@type table<string, lsp_toggle.tb_server>
M.clients = {}

function M.load_all_clients()
	local clients = vim.lsp.get_clients()
	local excluded = require('lsp-toggle.config').options.exclude_lsp

	for _, client in ipairs(clients) do
		if not vim.tbl_contains(excluded, client.name) then
			M.clients[client.name] = {
				enabled = vim.lsp.is_enabled(client.name),
				server_name = client.name,
				is_attached = function()
					-- NOTE: Using `pairs()` because it is not a list, strictly
					for _, v in pairs(client.attached_buffers) do
						if v then
							return true
						end
					end
					return false
				end,
			}
		else
			M.clients[client.name] = nil
		end
	end
end

function M.merge_table_pf()
	local opts = require('lsp-toggle.config').options

	M.load_all_clients()
	local file_clients = opts.cache and fileutils.load() or {}
	local excluded = require('lsp-toggle.config').options.exclude_lsp

	-- merge tables with priority to file
	for name, client in pairs(M.clients) do
		local added = false

		if opts.exclusive_mode then
			client.enabled = false
		end

		if vim.tbl_contains(excluded, name) then
			goto continue
		end

		for fname, fclient in pairs(file_clients) do
			if fname == name then
				M.clients[fname] = fclient
				added = true
			end
		end
		if not added then
			M.clients[name] = client
		end
		::continue::
	end
end

return M

-- vim:ts=4:sts=4:sw=0:noet:ai:si:sta:
