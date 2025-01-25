vim.cmd [[
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
]]

vim.cmd [[
call plug#begin('~/.vim/plugged')

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'MunifTanjim/prettier.nvim'

Plug 'jose-elias-alvarez/null-ls.nvim'

Plug 'mfussenegger/nvim-dap'

Plug 'glepnir/lspsaga.nvim'

Plug 'lewis6991/gitsigns.nvim'

" Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'simrat39/rust-tools.nvim'

call plug#end()
]]

vim.opt.completeopt = { "menu", "menuone", "noselect" } 
vim.opt.termguicolors = true 
vim.opt.number = true
vim.opt.relativenumber = true 
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "javascript", "typescript", "rust", "lua" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false  },
}

local lspconfig = require'lspconfig'
lspconfig.ts_ls.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  end
}

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

local prettier = require("prettier")
prettier.setup({
  bin = 'prettier',
  filetypes = { "javascript", "typescript", "css", "html", "json" }
})

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.code_actions.eslint,
    null_ls.builtins.formatting.prettier,
  }
})

local rust_tools = require('rust-tools')
rust_tools.setup({
  server = {
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = { command = "clippy" }      },
    },
  },
})

require'telescope'.setup{}

require'nvim-tree'.setup {
  view = {
    side = "left",
    width = 30,     
},
  renderer = {
    highlight_git = true,     
    highlight_opened_files = "all", 
    },
  actions = {
    open_file = {
      resize_window = true, 
      },
  },
}
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

vim.cmd [[
autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx,*.json Prettier
]]

