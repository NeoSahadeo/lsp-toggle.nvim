# LSP-Toggle

A plugin to toggle lsps. It has a persistent cache so settings are saved!

https://github.com/user-attachments/assets/fb71f7af-d6b3-44a2-ae42-b90e6d3fb63e

## Installation

### Lazy.nvim

```lua
return {
	config = function()
		require('lsp-toggle').setup()
	end,
	'NeoSahadeo/lsp-toggle.nvim',
}
```

## Usage

To toggle the menu, run:

```vim
:ToggleLSP
```

To clear the cache, run:

```vim
:ToggleLSPClearCache
```
