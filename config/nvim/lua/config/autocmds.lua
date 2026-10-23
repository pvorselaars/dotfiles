local augroup = vim.api.nvim_create_augroup("config", { clear = true })

-- LSP keys exist only in buffers with a language server attached.
-- Built in (Neovim 0.11+): K hover, grn rename, gra code action, grr references,
-- gri implementation, grt type definition, gO document symbols, ]d [d diagnostics, <C-s> signature help.
vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(args)
        local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
        end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
        map("<leader>cl", vim.lsp.codelens.run, "Run code lens")
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    callback = function() vim.hl.on_yank() end,
})
