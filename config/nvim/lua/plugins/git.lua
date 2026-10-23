return {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite" },
    keys = {
        { "<leader>gg", "<cmd>Git<CR>", desc = "Status" },
        { "<leader>gc", "<cmd>Git commit<CR>", desc = "Commit" },
        { "<leader>gP", "<cmd>Git push<CR>", desc = "Push" },
        { "<leader>gF", "<cmd>Git pull<CR>", desc = "Pull" },
        { "<leader>gl", "<cmd>Git log --oneline --graph --decorate<CR>", desc = "Log" },
        { "<leader>gB", "<cmd>Git blame<CR>", desc = "Blame whole file" },
    },
}
