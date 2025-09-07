local M = {
	cache_path = vim.fn.stdpath('cache'),
	file_path = '', -- set to empty string to avoid null
}
M.root_dir = M.cache_path .. '/lsp-toggle/'

local function djb2(str)
	local hash = 5381
	for i = 1, #str do
		local c = string.byte(str, i)
		hash = hash * 33 + c
	end
	return hash
end

function M.produce_path()
	if M.file_path == '' then
		print('[File] Cannot connect to buffer!')
		return nil
	else
		-- print(M.file_path)
		vim.fn.mkdir(M.root_dir, 'p')
		return M.root_dir .. djb2(M.file_path) .. '.json'
	end
end

function M.save(data)
	local path = M.produce_path()
	-- print('saving', path)
	if path then
		local fh = io.open(path, 'w')
		if fh then
			fh:write(vim.fn.json_encode(data))
			fh:close()
			return true
		end
	end
	return nil
end

function M.load()
	-- returns lspClients
	local path = M.produce_path()
	if path then
		local fh = io.open(path, 'r')
		if fh then
			local content = fh:read('*a')
			fh:close()
			return vim.fn.json_decode(content)
		end
	end
	return nil
end

return M
