vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.NvimTreeToggle)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[LSP] Go to Definition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[LSP] Go to Declaration' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = '[LSP] Go to Implementation' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = '[LSP] Go to References' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = '[LSP] Hover/Docs' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[LSP] Rename Symbol' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[LSP] Code Action' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = '[LSP] Prev Diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = '[LSP] Next Diagnostic' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = '[LSP] Show Diagnostics' })
vim.keymap.set('n', '<leader>F', function() vim.lsp.buf.format { async = true } end, { desc = '[LSP] Format Buffer' })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>m", ":w<CR> :make<CR>");
vim.keymap.set("n", "<leader>a", ":w<CR> :!compiler %<CR>");
vim.keymap.set("n", "<leader>f", ":w<CR> :!formatter %<CR>");

vim.keymap.set("n", "<leader>v", ":vsp<CR>");
vim.keymap.set("n", "<leader>h", ":hsp<CR>");
vim.keymap.set("n", "<leader>o", ":only<CR>");

vim.keymap.set("n", "<C-h>", "<C-w>h<CR>");
vim.keymap.set("n", "<C-j>", "<C-w>j<CR>");
vim.keymap.set("n", "<C-k>", "<C-w>k<CR>");
vim.keymap.set("n", "<C-l>", "<C-w>l<CR>");

vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
