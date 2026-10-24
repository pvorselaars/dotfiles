local augroup = vim.api.nvim_create_augroup("config", { clear = true })

-- LSP keys exist only in buffers with a language server attached.
-- Built in (Neovim 0.11+): K hover, grn rename, gra code action, grr references,
-- gri implementation, grt type definition, gO document symbols, ]d [d diagnostics, <C-s> signature help.
vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(args)
        local function map(lhs, rhs, desc, mode)
            vim.keymap.set(mode or "n", lhs, rhs, { buffer = args.buf, desc = desc })
        end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
        map("<leader>cl", vim.lsp.codelens.run, "Run code lens")

        -- Rider's own keys (its keymap here is "VSCode"), so the same fingers work in both. The <leader> and g keys above
        -- are the same in Rider too, through IdeaVim (~/.ideavimrc).
        -- Left out on purpose: Ctrl+Shift+R (refactor) and Ctrl+Shift+O (file structure), which the terminal (foot) keeps for
        -- itself; <leader>cR and <leader>fs do the same in both editors. Ctrl+T stays Vim's jump back (Rider: go to symbol,
        -- which is <leader>fS); Alt+Left does the jump back as well.
        local function pick(name, opts) return function() require("telescope.builtin")[name](opts) end end
        local function kind(only, apply)
            return function() vim.lsp.buf.code_action({ context = { only = { only } }, apply = apply }) end
        end
        local format = function() require("conform").format({ async = true, lsp_format = "fallback" }) end
        local jump = function(count) return function() vim.diagnostic.jump({ count = count, float = true }) end end

        map("<F12>", vim.lsp.buf.definition, "Go to definition (Rider: F12)")
        map("<C-F12>", pick("lsp_implementations"), "Go to implementation (Rider: Ctrl+F12)")
        map("<A-F12>", pick("lsp_implementations", { jump_type = "never" }), "Peek implementations (Rider: Alt+F12)")
        map("<S-F12>", pick("lsp_references", { include_declaration = false, jump_type = "never" }), "Show usages (Rider: Shift+F12)")
        map("<A-S-F12>", vim.lsp.buf.references, "Find usages in the quickfix list (Rider: Shift+Alt+F12)")
        map("<F2>", vim.lsp.buf.rename, "Rename (Rider: F2)")
        map("<C-.>", vim.lsp.buf.code_action, "Quick fix, code action (Rider: Ctrl+.)", { "n", "x" })
        map("<leader>cR", kind("refactor"), "Refactor this (Rider: Ctrl+Shift+R)")
        map("<C-S-Space>", vim.lsp.buf.signature_help, "Parameter info (Rider: Ctrl+Shift+Space)", { "n", "i" })
        map("<A-F>", format, "Format (Rider: Shift+Alt+F)", { "n", "x" })
        map("<A-O>", kind("source.organizeImports", true), "Optimize imports (Rider: Shift+Alt+O)")
        map("<C-S-m>", pick("diagnostics"), "Problems in the project (Rider: Ctrl+Shift+M)")
        map("<A-F8>", jump(1), "Next problem (Rider: Alt+F8)")
        map("<S-F8>", jump(-1), "Previous problem (Rider: Shift+F8)")
        map("<A-H>", vim.lsp.buf.incoming_calls, "Call hierarchy (Rider: Shift+Alt+H)")
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    callback = function() vim.hl.on_yank() end,
})

-- the refer-format bibliography in ~/Projects/bibliography has no extension
vim.filetype.add({ pattern = { [".*/bibliography/references"] = "refer" } })
