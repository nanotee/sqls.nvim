# sqls.nvim

Neovim plugin for [sqls](https://github.com/lighttiger2505/sqls) that leverages the built-in LSP client. Loosely based on the code from [sqls.vim](https://github.com/lighttiger2505/sqls.vim). Requires Neovim 0.8.0+

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

## Commands

See [sqls-nvim-commands](doc/sqls-nvim.txt#L14)

## Mappings

See [sqls-nvim-maps](doc/sqls-nvim.txt#L54)

## Events

See [sqls-nvim-events](doc/sqls-nvim.txt#L66)
