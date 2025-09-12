<div align="center">

# LSP-Toggle

A plugin to toggle LSP clients. It has a persistent cache so settings are saved!

https://github.com/user-attachments/assets/fb71f7af-d6b3-44a2-ae42-b90e6d3fb63e

</div>

## Installation

Requires nvim v0.11 or higher.

### Lazy.nvim

```lua
return {
	'NeoSahadeo/lsp-toggle.nvim',
  opts = {
    --- If less than `1`, this will revert back to `20`
    max_height = 20,

    --- If less than `1`, this will revert back to `30`
    max_width = 30,

    --- A list of LSP server names to exclude,
    --- e.g. `{ 'lua_ls', 'clangd' }` and so on...
    ---@type string[]
    exclude_lsp = {},

    ---@type string[]|'double'|'none'|'rounded'|'shadow'|'single'|'solid'
    border = { '╔', '-', '╗', '║', '╝', '═', '╚', '║' },

    -- Enable/Disable caching
    cache = true,
  },
}
```

### pckr.nvim

```lua
require('pckr').add({
	'NeoSahadeo/lsp-toggle.nvim',
  config = function()
    require('lsp-toggle').setup({
      --- If less than `1`, this will revert back to `20`
      max_height = 20,

      --- If less than `1`, this will revert back to `30`
      max_width = 30,

      --- A list of LSP server names to exclude,
      --- e.g. `{ 'lua_ls', 'clangd' }` and so on...
      ---@type string[]
      exclude_lsp = {},

      ---@type string[]|'double'|'none'|'rounded'|'shadow'|'single'|'solid'
      border = { '╔', '-', '╗', '║', '╝', '═', '╚', '║' },

      -- Enable/Disable caching
      cache = true,
    })
  end,
})
```

## Usage

To toggle the menu, run the following in the cmdline:

```vim
:ToggleLSP
```

To clear the cache, run the following in the cmdline:

```vim
:ToggleLSPClearCache
```

# Contributors

- @[DrKJeff16](https://github.com/DrKJeff16) **Contributor**
- @[NeoSahadeo](https://github.com/NeoSahadeo) **Maintainer *(Current owner)***
