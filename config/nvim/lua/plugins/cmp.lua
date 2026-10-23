return {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "micangl/cmp-vimtex",
    },
    config = function()
        local cmp = require("cmp")

        vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

        cmp.setup({
            completion = { completeopt = "menu,menuone,noinsert" },
            snippet = {
                expand = function(args) vim.snippet.expand(args.body) end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-CR>"] = function(fallback)
                    cmp.abort()
                    fallback()
                end,
            }),
            sources = cmp.config.sources({
                { name = "lazydev", group_index = 0 },
                { name = "nvim_lsp" },
                { name = "path" },
            }, {
                { name = "buffer" },
            }),
            formatting = {
                -- keep the popup narrow: cut long names and descriptions
                format = function(_, item)
                    local widths = { abbr = 40, menu = 30 }
                    for key, width in pairs(widths) do
                        if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                            item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
                        end
                    end
                    return item
                end,
            },
        })

        -- \cite{} keys (title and author in the menu), labels, commands and packages from vimtex
        cmp.setup.filetype("tex", {
            sources = cmp.config.sources({
                { name = "vimtex" },
                { name = "path" },
            }, {
                { name = "buffer" },
            }),
        })
    end,
}
