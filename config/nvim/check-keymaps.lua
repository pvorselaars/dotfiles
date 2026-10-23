-- Verifies KEYMAPS.md against the real mappings. Run through check-keymaps.sh, which opens
-- the right kind of file for each context (CHECK_CONTEXT): global, lsp, git or tex.
local context = vim.env.CHECK_CONTEXT
local md = vim.env.KEYMAPS_MD

local function wait(cond, ms) vim.wait(ms, cond, 100) end

if context == "lsp" then
    wait(function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end, 20000)
    wait(function() return false end, 1500) -- let on-attach keymaps settle
elseif context == "git" then
    wait(function() return vim.b.gitsigns_status_dict ~= nil end, 10000)
    wait(function() return false end, 800)
else
    wait(function() return false end, 1500)
end

local modes = { n = "n", x = "x", i = "i", t = "t", o = "o" }
local current, checked, missing = nil, 0, {}

for line in io.lines(md) do
    local ctx = line:match("^<!%-%- check: (%w+) %-%->")
    if ctx then current = ctx end
    local key, mode = line:match("^| `([^`]+)` | ([nxiot ]+) |")
    if key and current == context then
        local lhs = key:gsub("<leader>", "<Space>"):gsub("<localleader>", ",")
        for m in mode:gmatch("%a") do
            checked = checked + 1
            if next(vim.fn.maparg(lhs, modes[m], false, true)) == nil then
                table.insert(missing, ("%s (%s)"):format(key, m))
            end
        end
    end
end

print(("%-7s checked %d keys, missing %d"):format(context, checked, #missing))
for _, m in ipairs(missing) do print("  MISSING " .. m) end
vim.cmd(#missing == 0 and "qa!" or "cquit")
