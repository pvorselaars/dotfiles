return {
    "lervag/vimtex",
    lazy = false,
    init = function()
        vim.g.vimtex_view_method = "zathura"
        -- latexmk runs biber by itself when the document uses biblatex; xelatex for fontspec documents
        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_compiler_latexmk_engines = { _ = "-xelatex" }
        vim.g.vimtex_quickfix_mode = 2 -- open the quickfix window on errors, keep the cursor where it is
        vim.g.vimtex_quickfix_open_on_warning = 0
    end,
}
