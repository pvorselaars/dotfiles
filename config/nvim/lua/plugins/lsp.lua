return {
    {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
	    { "mason-org/mason.nvim", opts = {} },
	    "neovim/nvim-lspconfig",
	},
	opts = {
	    ensure_installed = { "lua_ls" }
	},
	automatic_enable = true
    },
    {
	"seblyng/roslyn.nvim",
	---@module 'roslyn.config'
	---@type RoslynNvimConfig
	opts = {
	    -- your configuration comes here; leave empty for default settings
	},
    }
}
