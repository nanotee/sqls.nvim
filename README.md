# sqls.nvim

Neovim plugin for [sqls](https://github.com/lighttiger2505/sqls) that leverages the built-in LSP client. Loosely based on the code from [sqls.vim](https://github.com/lighttiger2505/sqls.vim)

## Installation

```lua
-- packer.nvim
use 'nanotee/sqls.nvim'

-- paq-nvim
paq 'nanotee/sqls.nvim'
```

```vim
" vim-plug
Plug 'nanotee/sqls.nvim'
```

## Usage

Setup the plugin with [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)

```lua
require'lspconfig'.sqls.setup{
    on_attach = function(client)
        client.resolved_capabilities.execute_command = true

        require'sqls'.setup{}
    end
}
```

Available commands:

- `:SqlsExecuteQuery`: In normal mode, executes the query in the current buffer. In visual mode, executes the selected query (only works line-wise). Shows the results in a preview buffer.
- `:SqlsExecuteQueryVertical`: Same as `:SqlsExecuteQuery`, but the results are displayed vertically.
- `:SqlsShowDatabases`: Shows a list of available databases in a preview buffer.
- `:SqlsShowSchemas`: Shows a list of available schemas in a preview buffer.
- `:SqlsShowConnections`: Shows a list of available database connections in a preview buffer.
- `:SqlsSwitchDatabase {database_name}`: Switches to a different database. If {database_name} is omitted, displays an interactive prompt to select a database.
- `:SqlsSwitchConnection {connection_index}`: Switches to a different database connection. If {connection_index} is omitted, displays an interactive prompt to select a connection.

Commands using a preview buffer also support modifiers like `:vertical` or `:tab`.

## Configuration

The plugin can be configured by passing a table to the `setup()` function. Available options:

```lua
require'sqls'.setup{
    picker = 'default', -- Picker for choosing a database or a connection.
                        -- Available pickers:
                        -- - `default`: basic picker based on `inputlist()`
                        -- - `fzf`: requires the `fzf.vim` script
                        -- - `telescope`: requires the `telescope.nvim` plugin
}
```
