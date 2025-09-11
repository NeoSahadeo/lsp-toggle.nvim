local M = {}

M.root_dir = vim.fn.stdpath('cache') .. '/lsp-toggle/'

-- Set to empty string to avoid null
M.file_path = ''

---@param str string
---@return string hash
local function djb2(str)
	local hash = 5381
	for i = 1, str:len() do
		local c = str:byte(i)
		hash = hash * 33 + c
	end

	return tostring(hash)
end

---@param path string
function M.set_file_path(path)
	M.file_path = path
end

---@return string
function M.produce_path()
	if vim.fn.mkdir(M.root_dir, 'p') ~= 1 then
		error('[File] Failed to create directory!', vim.log.levels.ERROR)
	end

	return M.root_dir .. djb2(M.file_path) .. '.json'
end

---@param data table<string, { enabled: boolean, server_name: string }>
---@return boolean|nil
function M.save(data)
	local path = M.produce_path()

	if not path then
		return nil
	end

	local fd = vim.uv.fs_open(path, 'w', tonumber('644', 8))
	if not fd then
		return nil
	end

	vim.uv.fs_write(fd, vim.fn.json_encode(data))
	vim.uv.fs_close(fd)
	return true
end

---@return table<string, { enabled: boolean, server_name: string }>|nil
function M.load()
	-- returns lspClients
	local path = M.produce_path()
	if not path then
		return nil
	end

	local stat = vim.uv.fs_stat(path)
	if not stat then
		return nil
	end

	local fd = vim.uv.fs_open(path, 'r', tonumber('644', 8))

	if not fd then
		return nil
	end

	local content = vim.uv.fs_read(fd, stat.size)
	vim.uv.fs_close(fd)
	if not content then
		return nil
	end

	return vim.fn.json_decode(content)
end

return M
