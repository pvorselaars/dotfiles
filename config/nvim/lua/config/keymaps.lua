vim.g.mapleader = " "
vim.g.maplocalleader = ","

local map = vim.keymap.set

-- editing
map("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("x", "<", "<gv", { desc = "Indent left, keep selection" })
map("x", ">", ">gv", { desc = "Indent right, keep selection" })
map({ "n", "x" }, "<leader>x", [["_d]], { desc = "Delete without yanking" })
map("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting the register" })
map({ "n", "x" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- movement: keep the cursor centred
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
map("n", "n", "nzzzv", { desc = "Next match" })
map("n", "N", "Nzzzv", { desc = "Previous match" })
map("n", "<A-Left>", "<C-o>", { desc = "Back in the jump list (Rider: Alt+Left)" })
map("n", "<A-Right>", "<C-i>", { desc = "Forward in the jump list (Rider: Alt+Right)" })

-- windows
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Taller" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Shorter" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Narrower" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Wider" })
map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
map("n", "<leader>ws", "<cmd>split<CR>", { desc = "Split horizontally" })
map("n", "<leader>wo", "<cmd>only<CR>", { desc = "Close all other windows" })
map("n", "<leader>wc", "<cmd>close<CR>", { desc = "Close window" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize windows" })

-- buffers (]b and [b are built in)
map("n", "<leader>bb", "<cmd>buffer #<CR>", { desc = "Alternate buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bD", "<cmd>bdelete!<CR>", { desc = "Delete buffer, discard changes" })

-- files
map("n", "<leader>e", "<cmd>Explore<CR>", { desc = "File explorer (this file's folder)" })

-- search and replace
map("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

-- run and build
map("n", "<leader>rm", "<cmd>write<CR><cmd>make<CR>", { desc = "Save and make" })
map("n", "<leader>rc", "<cmd>write<CR><cmd>!compiler %<CR>", { desc = "Save, compile and run this file" })

-- quickfix (]q and [q are built in)
map("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Open quickfix list" })
map("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close quickfix list" })

-- terminal
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Leave terminal mode" })

-- UI toggles
map("n", "<leader>uw", function() vim.wo.wrap = not vim.wo.wrap end, { desc = "Toggle wrap" })
map("n", "<leader>un", function() vim.wo.relativenumber = not vim.wo.relativenumber end, { desc = "Toggle relative numbers" })
map("n", "<leader>us", function() vim.wo.spell = not vim.wo.spell end, { desc = "Toggle spell check" })
map("n", "<leader>ud", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = "Toggle diagnostics" })
map("n", "<leader>uh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { desc = "Toggle inlay hints" })

-- measure and profile (see lua/config/measure.lua and ~/Projects/scripts/PROFILING.md)
local function measure(fn, ...)
    local args = { ... }
    return function() require("config.measure")[fn](unpack(args)) end
end
map("n", "<leader>mb", measure("run", "bench"), { desc = "Benchmark (timing, compared with last run)" })
map("n", "<leader>mc", measure("compare"), { desc = "Compare the last two benchmarks" })
map("n", "<leader>ms", measure("run", "stat"), { desc = "Counters (perf stat, .NET counters)" })
map("n", "<leader>mf", measure("run", "flame"), { desc = "Flame graph" })
map("n", "<leader>mg", measure("hotspot"), { desc = "Open the last flame recording in hotspot (GUI)" })
map("n", "<leader>mk", measure("run", "callgrind"), { desc = "Instruction counts (callgrind)" })
map("n", "<leader>mh", measure("run", "heap"), { desc = "Heap: allocations and leaks" })
map("n", "<leader>mr", measure("repeat_last"), { desc = "Repeat the last measurement" })
map("n", "<leader>mo", measure("open_results"), { desc = "Open the .bench results folder" })
