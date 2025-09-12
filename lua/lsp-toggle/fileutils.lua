local M = {}

M.root_dir = vim.fn.stdpath('cache') .. '/lsp-toggle'

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

	return string.format('%s/%s.json', M.root_dir, djb2(M.file_path))
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

---@param path? string
function M.clear_cache(path)
	path = path or M.root_dir

	local stat = vim.uv.fs_stat(path)

	if not stat or stat.type ~= 'directory' then
		vim.notify('No cache to clear!', vim.log.levels.WARN)
		return nil
	end

	local dir = vim.uv.fs_scandir(path)

	while true do
		---@type string?, 'directory'|'file'?
		local item, item_type = vim.uv.fs_scandir_next(dir)

		if not item then
			break
		end

		item = path .. '/' .. item

		if item_type == 'file' then
			vim.uv.fs_unlink(item)
		elseif item_type == 'directory' then
			M.clear_cache(item)
		end
	end

	return vim.uv.fs_rmdir(path)
end

return M

-- vim:ts=4:sts=4:sw=0:noet:ai:si:sta:
