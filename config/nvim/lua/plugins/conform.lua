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
            c = { "indent_linux" },
        },
        formatters = {
            -- same flags as the `formatter` script in ~/Projects/scripts
            indent_linux = {
                command = "indent",
                args = { "-linux", "-sob", "-l120", "-lc120" },
                stdin = true,
            },
        },
        -- everything else (C#, Lua, ...) is formatted by its language server
        default_format_opts = { lsp_format = "fallback" },
    },
}
