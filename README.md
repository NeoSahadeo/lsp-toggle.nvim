# LSP-Toggle

A plugin to toggle lsps. It has a persistent cache so settings are saved!

<video src="https://i.imgur.com/8czbvsI.mp4" controls width="640" />

# Installation

__Lazy__

```lua
return {
	'https://github.com/NeoSahadeo/lsp-toggle.nvim/',
	config = function()
		require('lsp-toggle').setup()
	end,
}
```

# Usage

To toggle the menu run

```vimscript
:ToggleLSP
```


To clear the cache run

```vimscript
:ToggleLSPClearCache
```
