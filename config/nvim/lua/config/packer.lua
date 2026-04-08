vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = 'v0.1.9',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	use 'olimorris/onedarkpro.nvim'
	use 'mbbill/undotree'
	use 'tpope/vim-fugitive'
	use {
		'nvim-treesitter/nvim-treesitter', tag = 'latest',
		{ run = ':TSUpdate' }
	}
	use 'neovim/nvim-lspconfig'
	use 'mason-org/mason.nvim'
	use 'mason-org/mason-lspconfig.nvim'

	use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} }

	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'
	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional
		},
	}
    use 'lewis6991/gitsigns.nvim'
end)
