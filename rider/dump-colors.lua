-- Writes the colours Neovim really uses (after the One Dark theme and the overrides in lua/plugins/colors.lua) as JSON,
-- for make-onedark-scheme.js. Run it with Neovim's config loaded:
--   RIDER_COLORS_OUT=file.json nvim --headless -c "luafile dump-colors.lua" -c "qa!"
local function hex(n) return n and string.format("#%06x", n) or nil end

local function get(name)
    local h = vim.api.nvim_get_hl(0, { name = name, link = false })
    return { fg = hex(h.fg), bg = hex(h.bg), italic = h.italic or false, bold = h.bold or false }
end

local style = (vim.g.onedark_config and vim.g.onedark_config.style) or "darker"
local out = { style = style, palette = require("onedark.palette")[style], groups = {} }

for _, name in ipairs({
    "@keyword", "@string", "@number", "@comment", "@comment.documentation", "@function", "@type", "@variable",
    "@variable.parameter", "@variable.member", "@constant", "@string.escape", "@tag", "@tag.attribute",
    "@operator", "@punctuation.bracket", "@attribute", "@module", "@markup.link",
    "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint",
    "CursorLine", "Visual", "LineNr", "CursorLineNr", "Pmenu", "LspReferenceText",
    "DiffAdd", "DiffDelete", "DiffChange", "DiffText", "GitSignsAdd", "GitSignsChange", "GitSignsDelete",
}) do
    out.groups[name] = get(name)
end

local file = assert(io.open(assert(os.getenv("RIDER_COLORS_OUT"), "set RIDER_COLORS_OUT"), "w"))
file:write(vim.json.encode(out))
file:close()
