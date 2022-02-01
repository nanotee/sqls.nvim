# sqls.nvim

Neovim plugin for [sqls](https://github.com/lighttiger2505/sqls) that leverages the built-in LSP client. Loosely based on the code from [sqls.vim](https://github.com/lighttiger2505/sqls.vim). Requires Neovim 0.5.1+

## Installation

- [packer.nvim](https://github.com/wbthomason/packer.nvim)
    ```lua
    use 'nanotee/sqls.nvim'
    ```
- [paq-nvim](https://github.com/savq/paq-nvim)
    ```lua
    paq 'nanotee/sqls.nvim'
    ```
- [vim-plug](https://github.com/junegunn/vim-plug)
    ```vim
    Plug 'nanotee/sqls.nvim'
    ```

## Usage

Setup the plugin with [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)

```lua
require('lspconfig').sqls.setup{
    on_attach = function(client, bufnr)
        require('sqls').on_attach(client, bufnr)
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

Available mappings:

- `<Plug>(sqls-execute-query)`: In visual mode, executes the selected range. In normal mode, executes a motion (like `ip` or `aw`)
- `<Plug>(sqls-execute-query-vertical)`: same as `<Plug>(sqls-execute-query)`, but the results are displayed vertically

Status bar support:

After choosing a connection you can ask for the currently selected connection
and database like this:

```lua
local status = require("sqls.commands").status
-- status.connection: name of the connection name in the configuration file
-- status.database: name of the connected database
```
