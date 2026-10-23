-- C#: `:make` (and <leader>rm, which saves first) runs `dotnet build` on the solution or project above
-- this file and puts the compiler errors in the quickfix list, so ]q [q and <leader>qo
-- jump to them. The quickfix window opens by itself when there is something in it.

-- the solution above this file, or else its project
local function build_target()
    local dir = vim.fn.expand("%:p:h")
    for _, pattern in ipairs({ "%.slnx?$", "%.csproj$" }) do
        local found = vim.fs.find(function(name) return name:match(pattern) end, { upward = true, path = dir, limit = 1 })
        if found[1] then return found[1] end
    end
end

-- -tl:off -clp:ErrorsOnly: errors only, each once. MSBuild repeats every error in its summary, and a big
-- solution has hundreds of warnings; this keeps the quickfix list to what stops the build.
local target = build_target()
vim.bo.makeprg = "dotnet build -nologo -v q -tl:off -clp:ErrorsOnly" .. (target and (" " .. vim.fn.shellescape(target)) or "")

-- MSBuild lines, e.g.
--   /src/Program.cs(5,9): error CS1002: ; expected [/src/App.csproj]
--   /src/App.csproj : error NU1101: Unable to find package ...
--   MSBUILD : error MSB1011: Specify which project or solution file to use ...
-- %t takes the first letter of "error" / "warning"; %*[a-z] skips the rest of the word
vim.bo.errorformat = table.concat({
    "%f(%l\\,%c): %t%*[a-z] %m",
    "%f(%l): %t%*[a-z] %m",
    "%f : %t%*[a-z] %m",
    "MSBUILD : %t%*[a-z] %m",
    "%-G%.%#",
}, ",")

local group = vim.api.nvim_create_augroup("cs_make", { clear = true })
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    group = group,
    pattern = "make",
    callback = function()
        if vim.bo.filetype == "cs" then vim.cmd("cwindow") end
    end,
})
