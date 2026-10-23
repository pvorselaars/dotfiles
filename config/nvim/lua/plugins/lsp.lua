return {
    {
        "mason-org/mason.nvim",
        opts = {
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry", -- roslyn
            },
        },
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            -- texlab: references, symbols and gd from \cite{} to the .bib entry; ltex_plus: grammar and spelling
            ensure_installed = { "lua_ls", "clangd", "texlab", "ltex_plus" },
        },
        config = function(_, opts)
            -- only LaTeX: notes in markdown stay free of grammar warnings; the language is detected per document
            vim.lsp.config("ltex_plus", {
                filetypes = { "tex" },
                settings = { ltex = { language = "auto" } },
            })
            require("mason-lspconfig").setup(opts)
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = { "roslyn", "netcoredbg", "tex-fmt" },
        },
    },
    {
        "seblyng/roslyn.nvim",
        ft = { "cs", "razor" },
        opts = {},
    },
}
