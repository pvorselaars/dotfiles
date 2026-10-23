-- Measure and profile the thing in the current buffer. The work is done by `bench` and `prof`
-- (~/Projects/scripts); this module only decides WHAT to run and shows the result in a terminal split.
--   C file       -> `prof build FILE.c`, then run the optimised binary
--   C# file      -> Release build of the nearest .csproj, then `dotnet app.dll`
--   anything else -> asks for the command
local M = {}

local last_args = {} -- remembered per target, so repeating is one Enter
local last_run       -- { cmd = ..., cwd = ... } for M.repeat_last()

local function notify(msg, level) vim.notify(msg, level or vim.log.levels.INFO, { title = "measure" }) end

local function target()
    local file = vim.api.nvim_buf_get_name(0)
    local ft = vim.bo.filetype
    if ft == "c" then
        local src = vim.fn.fnamemodify(file, ":p")
        local name = vim.fn.fnamemodify(src, ":t:r")
        return { kind = "c", cwd = vim.fs.dirname(src), name = name, src = src }
    elseif ft == "cs" then
        local root = vim.fs.root(0, function(n) return n:match("%.csproj$") ~= nil end)
        if not root then return nil, "no .csproj found above this file" end
        return { kind = "cs", cwd = root, name = vim.fs.basename(root) }
    end
    local cwd = vim.fn.getcwd()
    return { kind = "cmd", cwd = cwd, name = vim.fs.basename(cwd) }
end

local function term(cmd, cwd, opts)
    last_run = { cmd = cmd, cwd = cwd }
    vim.cmd("botright 20new")
    local buf = vim.api.nvim_get_current_buf()
    vim.fn.jobstart({ "bash", "-c", cmd }, {
        term = true,
        cwd = cwd,
        on_exit = opts and opts.on_exit,
    })
    vim.bo[buf].bufhidden = "wipe"
    vim.keymap.set("n", "q", "<cmd>bdelete!<CR>", { buffer = buf, desc = "Close" })
    vim.cmd("normal! G")
    return buf
end

-- shell snippets that produce the program to run, as `prep` (build step) and `exe` (what to execute)
local function program(t, cmd_input)
    if t.kind == "c" then
        return "prof build " .. vim.fn.shellescape(t.src) .. " >/dev/null || exit 1", "./" .. vim.fn.shellescape(t.name .. "-prof")
    elseif t.kind == "cs" then
        return 'dll=$(prof net-build . 2>/dev/null) && [ -n "$dll" ] || { echo "build failed"; exit 1; }', 'dotnet "$dll"'
    end
    return nil, cmd_input
end

local function command_for(tool, t, exe_args, args)
    local q = vim.fn.shellescape
    if tool == "bench" then
        -- bench takes the whole command as one string; the shell expands $dll first, so quote it for hyperfine
        if t.kind == "cs" then return "bench -l " .. q(t.name) .. ' "dotnet \\"$dll\\" ' .. args .. '"' end
        return "bench -l " .. q(t.name) .. " " .. q(exe_args)
    elseif tool == "stat" then
        return (t.kind == "cs" and "prof net-counters -- " or "prof stat -- ") .. exe_args
    elseif tool == "flame" then
        return (t.kind == "cs" and "prof net-trace -- " or "prof flame -- ") .. exe_args
    elseif tool == "callgrind" or tool == "heap" then
        if t.kind == "cs" then return nil, "not available for .NET: use <leader>ms (counters) or `prof net-gc PID`" end
        return "prof " .. tool .. " -- " .. exe_args
    end
end

-- tool: bench | stat | flame | callgrind | heap. opts.args skips the prompt (used by tests).
function M.run(tool, opts)
    opts = opts or {}
    local t, err = target()
    if not t then return notify(err, vim.log.levels.WARN) end

    local function go(input)
        if input == nil then return end -- cancelled
        local prep, exe = program(t, input)
        local args = t.kind == "cmd" and "" or input
        local exe_args = (exe .. " " .. args):gsub("%s+$", "")
        local cmd, why = command_for(tool, t, exe_args, args)
        if not cmd then return notify(why, vim.log.levels.WARN) end
        if prep then cmd = prep .. " && " .. cmd end
        last_args[t.cwd .. t.kind] = input
        term(cmd, t.cwd, opts)
    end

    if opts.args ~= nil then return go(opts.args) end
    vim.ui.input({
        prompt = t.kind == "cmd" and "Command to measure: " or "Arguments for " .. t.name .. ": ",
        default = last_args[t.cwd .. t.kind] or "",
    }, go)
end

-- compare the two newest bench runs of this target (no prompt)
function M.compare(opts)
    local t, err = target()
    if not t then return notify(err, vim.log.levels.WARN) end
    term("bench -c " .. vim.fn.shellescape(t.name), t.cwd, opts)
end

function M.repeat_last(opts)
    if not last_run then return notify("nothing to repeat yet", vim.log.levels.WARN) end
    term(last_run.cmd, last_run.cwd, opts)
end

-- open the newest perf recording of this target in hotspot (GUI, detached)
function M.hotspot()
    local t, err = target()
    if not t then return notify(err, vim.log.levels.WARN) end
    vim.system({ "prof", "hotspot" }, { cwd = t.cwd, text = true }, function(r)
        vim.schedule(function()
            notify(vim.trim(r.code == 0 and r.stdout or r.stderr), r.code == 0 and vim.log.levels.INFO or vim.log.levels.WARN)
        end)
    end)
end

-- results folder (.bench) next to the code, in the file explorer; `gx` opens a file with the system viewer
function M.open_results()
    local t = target()
    local dir = (t and t.cwd or vim.fn.getcwd()) .. "/.bench"
    if vim.fn.isdirectory(dir) == 0 then return notify("no results yet in " .. dir, vim.log.levels.WARN) end
    vim.cmd("Explore " .. vim.fn.fnameescape(dir))
end

return M
