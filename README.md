# sqls.nvim

Neovim plugin for [sqls](https://github.com/sqls-server/sqls) that leverages the built-in LSP client. Loosely based on the code from [sqls.vim](https://github.com/sqls-server/sqls.vim). Requires Neovim >=0.11.0

## Installation

```lua
vim.pack.add({'https://github.com/nanotee/sqls.nvim'})
```

## Usage

Enable the configuration with [`vim.lsp.enable()`](https://neovim.io/doc/user/lsp.html#vim.lsp.enable()) and [`vim.lsp.config()`](https://neovim.io/doc/user/lsp.html#vim.lsp.config())

```lua
vim.lsp.config('sqls', {
    -- your custom client configuration
})
vim.lsp.enable('sqls')
```

See also: [`lsp-config`](https://neovim.io/doc/user/lsp.html#lsp-config)

## Configuration

```lua
vim.g.sqls_nvim = {
    -- render query results as a Markdown table (default: false)
    markdown_output = true,
}
```

Alternatively, call `require('sqls').setup({ markdown_output = true })`, which is what plugin managers like lazy.nvim do with `opts`.

Requires a version of `sqls` that supports the `-markdown` argument to `executeQuery`.

See [sqls-nvim-config](doc/sqls-nvim.txt#L15)

## Commands

See [sqls-nvim-commands](doc/sqls-nvim.txt#L38)

## Mappings

See [sqls-nvim-maps](doc/sqls-nvim.txt#L78)

## Events

See [sqls-nvim-events](doc/sqls-nvim.txt#L90)
