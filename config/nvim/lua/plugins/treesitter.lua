return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
	highlight = { enable = true },
	indent = { enable = true },
	autotags = { enable = true },
	ensure_installed = {
	    "lua",
	    "c",
	    "typescript",
	    "c_sharp",
	},
	auto_install = false,
    }
}
