return require'packer'.startup(function()
  use 'wbthomason/packer.nvim'
  use 'EdenEast/nightfox.nvim'
  use 'ryanoasis/vim-devicons'
  use 'norcalli/nvim-colorizer.lua'
  use 'easymotion/vim-easymotion'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use {
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons'
  }
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'
  use 'junegunn/goyo.vim'
  use 'karb94/neoscroll.nvim'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  use 'onsails/lspkind-nvim'

  use 'chentoast/marks.nvim'
  use 'iamcco/markdown-preview.nvim'


end)
