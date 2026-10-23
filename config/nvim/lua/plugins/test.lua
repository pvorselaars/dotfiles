return {
    "nvim-neotest/neotest",
    -- load with the C# buffer, not on the first key: tests must be discovered before a run
    ft = "cs",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "Issafalcon/neotest-dotnet",
    },
    keys = {
        { "<leader>tn", function() require("neotest").run.run() end, desc = "Test nearest" },
        { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test file" },
        { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
        { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Test last" },
        { "<leader>tx", function() require("neotest").run.stop() end, desc = "Stop test" },
        { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test summary" },
        { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test output" },
        { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Test output panel" },
    },
    init = function()
        -- Neovim 0.12 ignores iter_matches({ all = false }) and always returns lists of nodes, which breaks
        -- neotest-dotnet's framework detection. Restore the old behaviour for callers that ask for it.
        -- Remove once neotest-dotnet handles it upstream.
        local Query = getmetatable(vim.treesitter.query.parse("lua", "(identifier) @i")).__index
        local iter_matches = Query.iter_matches
        Query.iter_matches = function(self, node, source, start, stop, opts)
            if not (opts and opts.all == false) then
                return iter_matches(self, node, source, start, stop, opts)
            end
            local iter = iter_matches(self, node, source, start, stop, vim.tbl_extend("force", opts, { all = true }))
            return function()
                local pattern, match, metadata = iter()
                if not pattern then return nil end
                local single = {}
                for id, nodes in pairs(match) do
                    single[id] = type(nodes) == "table" and nodes[#nodes] or nodes
                end
                return pattern, single, metadata
            end
        end
    end,
    config = function()
        require("neotest").setup({
            adapters = { require("neotest-dotnet")({ dap = { adapter_name = "coreclr" } }) },
        })

        -- neotest parses test files in a child nvim started with -u NONE. That child does not know that
        -- the "cs" filetype uses the c_sharp parser, so discovery fails. Parse in-process instead.
        local ts = require("neotest.lib").treesitter
        ts.parse_positions = function(file_path, query, opts)
            return ts._parse_positions(file_path, query, opts)
        end
    end,
}
