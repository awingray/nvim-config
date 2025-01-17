-- Bootstrap Vim Plug
vim.cmd [[
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
]]

-- Plugins
vim.cmd [[
call plug#begin('~/.vim/plugged')

" Tree-sitter for better syntax highlighting and more
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" LSP support for JavaScript/TypeScript
Plug 'neovim/nvim-lspconfig'

" Completion plugins
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Prettier for formatting
Plug 'MunifTanjim/prettier.nvim'

" ESLint integration
Plug 'jose-elias-alvarez/null-ls.nvim'

" Debugging (DAP)
Plug 'mfussenegger/nvim-dap'

" Optional: Fancy UI for LSP
Plug 'glepnir/lspsaga.nvim'

" Git integration
Plug 'lewis6991/gitsigns.nvim'

" Optional: File Explorer
Plug 'kyazdani42/nvim-tree.lua'

" Optional: Telescope for fuzzy finding
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

call plug#end()
]]

-- General Settings
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- Completion options
vim.opt.termguicolors = true -- Better colors
vim.opt.number = true -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers

-- Treesitter Configuration
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "javascript", "typescript", "tsx", "html", "css", "json" }, -- Add other languages as needed
  highlight = { enable = true }, -- Enable syntax highlighting
  indent = { enable = true } -- Enable better indentation
}

-- LSP Configuration
local lspconfig = require'lspconfig'
lspconfig.ts_ls.setup {
  on_attach = function(client, bufnr)
    -- Disable formatting in tsserver (use prettier instead)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- Keybindings for LSP
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  end
}

-- Completion Configuration
local cmp = require'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body)
    end
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
}

-- Prettier Configuration
local prettier = require("prettier")
prettier.setup({
  bin = 'prettier',
  filetypes = { "javascript", "typescript", "css", "html", "json" }
})

-- Null-ls Configuration
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.code_actions.eslint,
    null_ls.builtins.formatting.prettier,
  }
})

-- Telescope Configuration
require'telescope'.setup{}

-- Optional: Automatically format on save
vim.cmd [[
autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx,*.json Prettier
]]

