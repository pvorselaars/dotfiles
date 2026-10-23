-- refer-format bibliography (~/Projects/bibliography/references).
-- Saving regenerates references.bib with refer2bib; :make only lints and fills the quickfix list.
local dir = vim.fn.expand("%:p:h")
local converter = dir .. "/refer2bib"

vim.bo.makeprg = converter .. " --check"
vim.bo.errorformat = "refer2bib: line %l: %m,%-G%.%#"
vim.bo.commentstring = "# %s"

vim.cmd([[
    syntax match referTag /^[%$]\a/
    syntax match referKey /^[%$]K.*/ contains=referTag
    syntax match referTitle /^%T.*/ contains=referTag
    syntax match referAuthor /^%A.*/ contains=referTag
    syntax match referUrl /https\?:\/\/\S\+/
    highlight default link referTag Special
    highlight default link referKey Identifier
    highlight default link referTitle Title
    highlight default link referAuthor String
    highlight default link referUrl Underlined
]])

if vim.fn.executable(converter) == 1 then
    vim.api.nvim_create_autocmd("BufWritePost", {
        buffer = 0,
        callback = function()
            vim.system({ converter }, { text = true }, vim.schedule_wrap(function(r)
                local problems = vim.tbl_filter(function(l) return l:find("line %d+:") and not l:find("note:") end,
                    vim.split(r.stderr or "", "\n"))
                local msg = #problems == 0 and "references.bib updated"
                    or ("references.bib updated, %d problem(s): :make"):format(#problems)
                vim.notify(msg, #problems == 0 and vim.log.levels.INFO or vim.log.levels.WARN)
            end))
        end,
    })
end
