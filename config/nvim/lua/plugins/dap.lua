return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            { "theHamsta/nvim-dap-virtual-text", opts = {} },
        },
        keys = {
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional breakpoint" },
            { "<leader>dc", function() require("dap").continue() end, desc = "Start / continue" },
            { "<leader>dn", function() require("dap").step_over() end, desc = "Step over (next)" },
            { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
            { "<leader>do", function() require("dap").step_out() end, desc = "Step out" },
            { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
            { "<leader>dg", function() require("dap").goto_() end, desc = "Jump to line (no execute)" },
            { "<leader>dj", function() require("dap").down() end, desc = "Stack frame down" },
            { "<leader>dk", function() require("dap").up() end, desc = "Stack frame up" },
            { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
            { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
            { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
            { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
            { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Inspect value under cursor" },
            { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle debug UI" },
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- netcoredbg is installed by mason (see lsp.lua)
            dap.adapters.coreclr = {
                type = "executable",
                command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
                args = { "--interpreter=vscode" },
            }

            dap.configurations.cs = {
                {
                    type = "coreclr",
                    name = "launch - netcoredbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
                    end,
                },
            }

            dapui.setup()

            dap.listeners.after.event_initialized["dapui_config"] = dapui.open
            dap.listeners.before.event_terminated["dapui_config"] = dapui.close
            dap.listeners.before.event_exited["dapui_config"] = dapui.close
        end,
    },
}
