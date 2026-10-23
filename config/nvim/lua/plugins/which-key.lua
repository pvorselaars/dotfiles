return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        spec = {
            { "<leader>b", group = "buffers" },
            { "<leader>c", group = "code" },
            { "<leader>d", group = "debug" },
            { "<leader>f", group = "find" },
            { "<leader>g", group = "git" },
            { "<leader>i", group = "icons" },
            { "<leader>m", group = "measure" },
            { "<leader>q", group = "quickfix" },
            { "<leader>r", group = "run" },
            { "<leader>s", group = "search" },
            { "<leader>t", group = "test" },
            { "<leader>u", group = "ui toggles" },
            { "<leader>w", group = "windows" },
            { "<leader>z", group = "notes" },
        },
    },
    keys = {
        { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Keymaps in this buffer" },
    },
}
