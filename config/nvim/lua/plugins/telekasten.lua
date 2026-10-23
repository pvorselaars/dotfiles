return {
    "renerocksai/telekasten.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = "Telekasten",
    opts = {
        home = vim.fn.expand("~/Notes"),
    },
    keys = {
        { "<leader>z", "<cmd>Telekasten panel<CR>", desc = "Notes panel" },
        { "<leader>zf", "<cmd>Telekasten find_notes<CR>", desc = "Find notes" },
        { "<leader>zg", "<cmd>Telekasten search_notes<CR>", desc = "Search notes" },
        { "<leader>zd", "<cmd>Telekasten goto_today<CR>", desc = "Today's note" },
        { "<leader>zz", "<cmd>Telekasten follow_link<CR>", desc = "Follow link" },
        { "<leader>zn", "<cmd>Telekasten new_note<CR>", desc = "New note" },
        { "<leader>zc", "<cmd>Telekasten show_calendar<CR>", desc = "Calendar" },
        { "<leader>zb", "<cmd>Telekasten show_backlinks<CR>", desc = "Backlinks" },
        { "<leader>zI", "<cmd>Telekasten insert_img_link<CR>", desc = "Insert image link" },
        { "<leader>zt", "<cmd>Telekasten toggle_todo<CR>", desc = "Toggle todo" },
        { "[[", "<cmd>Telekasten insert_link<CR>", mode = "i", desc = "Insert note link" },
    },
}
