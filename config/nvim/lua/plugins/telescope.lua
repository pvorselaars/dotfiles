local function pick(name, opts)
    return function() require("telescope.builtin")[name](opts) end
end

return {
    "nvim-telescope/telescope.nvim",
    tag = "v0.2.2",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-bibtex.nvim",
    },
    cmd = "Telescope",
    config = function()
        require("telescope").setup({
            extensions = {
                bibtex = {
                    -- the generated file from ~/Projects/bibliography (see refer2bib there)
                    global_files = { vim.fn.expand("~/Projects/bibliography/references.bib") },
                    context = true, -- also the .bib files this document loads
                    context_fallback = true, -- ... and the global file when it loads none
                    search_keys = { "author", "year", "title" },
                },
            },
        })
        require("telescope").load_extension("bibtex")
    end,
    keys = {
        { "<leader>ff", pick("find_files"), desc = "Files" },
        { "<leader>fg", pick("live_grep"), desc = "Grep" },
        { "<leader>fw", pick("grep_string"), desc = "Grep word under cursor", mode = { "n", "x" } },
        { "<leader>fb", pick("buffers"), desc = "Buffers" },
        { "<leader>fr", pick("oldfiles"), desc = "Recent files" },
        { "<leader>fR", pick("resume"), desc = "Resume last search" },
        { "<leader>fs", pick("lsp_document_symbols"), desc = "Symbols in file" },
        { "<leader>fS", pick("lsp_dynamic_workspace_symbols"), desc = "Symbols in project" },
        { "<leader>fd", pick("diagnostics", { bufnr = 0 }), desc = "Diagnostics in file" },
        { "<leader>fD", pick("diagnostics"), desc = "Diagnostics in project" },
        { "<leader>fh", pick("help_tags"), desc = "Help" },
        { "<leader>fk", pick("keymaps"), desc = "Keymaps" },
        { "<leader>fc", pick("commands"), desc = "Commands" },
        { "<leader>fB", "<cmd>Telescope bibtex<CR>", desc = "Citations (insert key)", mode = { "n", "i" } },
    },
}
