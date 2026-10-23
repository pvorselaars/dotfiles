return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        on_attach = function(bufnr)
            local gs = require("gitsigns")
            local function map(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end

            map("n", "]c", function()
                if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end
            end, "Next hunk")
            map("n", "[c", function()
                if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end
            end, "Previous hunk")

            -- in visual mode, act on the selected lines only
            local function hunk(action)
                return function()
                    if vim.fn.mode():match("[vV\22]") then
                        gs[action]({ vim.fn.line("."), vim.fn.line("v") })
                    else
                        gs[action]()
                    end
                end
            end

            map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
            map({ "n", "x" }, "<leader>gs", hunk("stage_hunk"), "Stage hunk")
            map({ "n", "x" }, "<leader>gr", hunk("reset_hunk"), "Reset hunk")
            map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
            map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
            map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
            map("n", "<leader>gd", gs.diffthis, "Diff against index")
            map("n", "<leader>gq", gs.setqflist, "Hunks to quickfix")
        end,
    },
}
