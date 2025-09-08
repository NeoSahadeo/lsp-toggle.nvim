vim.api.nvim_create_user_command('ToggleLSP', function()
	local window = require('lsp-toggle.window')

    if vim.tbl_isempty(vim.lsp.get_clients()) then
        vim.notify('No LSP servers available', vim.log.levels.WARN)
        return
    end

	-- toggle the window
	-- make sure LSP attaches the buffer
	window.toggle_window()
    window.update_window()
end, { desc = 'Toggle the window to display active LSP Servers' })
