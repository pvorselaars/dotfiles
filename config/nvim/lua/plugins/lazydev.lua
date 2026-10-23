return {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
        library = {
            -- load luv types when vim.uv is used
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    },
}
