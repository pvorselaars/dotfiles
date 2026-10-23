local parsers = {
    "bash", "c", "c_sharp", "css", "html", "javascript", "json", "lua",
    "markdown", "markdown_inline", "typescript", "vimdoc", "yaml",
}

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        -- installs only what is missing; runs in the background
        require("nvim-treesitter").install(parsers)

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                -- no parser for this filetype: leave regex highlighting alone
                if pcall(vim.treesitter.start, args.buf) then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
