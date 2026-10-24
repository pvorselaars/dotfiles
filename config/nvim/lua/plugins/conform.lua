return {
    "stevearc/conform.nvim",
    keys = {
        {
            "<leader>cf",
            function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
            mode = { "n", "v" },
            desc = "Format",
        },
    },
    opts = {
        formatters_by_ft = {
            tex = { "tex-fmt" },
        },
        -- C and C++ are formatted by clangd, with ~/.clang-format (tabs of 8, 120 columns, the style of `indent -linux`).
        -- Everything else (C#, Lua, ...) is formatted by its language server too
        default_format_opts = { lsp_format = "fallback" },
    },
}
