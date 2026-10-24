#!/usr/bin/env node
// Builds a Rider editor colour scheme, "One Dark (Neovim)", that has the colours of Neovim.
//
// It takes the colour scheme Rider ships with ("Rider Islands Dark", from the rider-theme-pack plugin of the installed
// Rider) and replaces every colour by the Neovim colour for the same role: keywords, strings, comments, types, ... The
// Neovim colours are read from a running Neovim (dump-colors.lua), so a change in lua/plugins/colors.lua carries over
// when you run this again. Only the editor colours change; the window colours (menus, tabs) come from a plugin, see install-one-dark-theme.
//
//   node make-onedark-scheme.js                 write the scheme to ./One\ Dark\ \(Neovim\).icls and check it
//   node make-onedark-scheme.js --install       also put it in Rider's settings and make it the active scheme
//
// Options: --out FILE, --rider-home DIR (the folder with plugins/), --config-dir DIR (Rider's settings folder).
// --install refuses to run while Rider is open: Rider writes its settings back when it closes and would undo it.
// To go back: restore options/colors.scheme.xml from colors.scheme.xml.before-onedark, or pick a scheme in Settings.
'use strict';
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { execFileSync, spawnSync } = require('node:child_process');

const NAME = 'One Dark (Neovim)';
const args = process.argv.slice(2);
const option = (name) => { const i = args.indexOf(name); return i >= 0 ? args[i + 1] : undefined; };
const fail = (message) => { console.error(`error: ${message}`); process.exit(1); };

// ---- inputs ----------------------------------------------------------------------------------------------------

function riderHome() {
  const candidates = [option('--rider-home'), process.env.RIDER_HOME, path.join(os.homedir(), '.local/share/JetBrains/Toolbox/apps/rider'), '/opt/rider'].filter(Boolean);
  const home = candidates.find((dir) => fs.existsSync(path.join(dir, 'plugins/rider-theme-pack/lib/rider-theme-pack.jar')));
  if (!home) fail(`no Rider with rider-theme-pack found (tried ${candidates.join(', ')}); use --rider-home`);
  return home;
}

function bundledScheme() {
  const jar = path.join(riderHome(), 'plugins/rider-theme-pack/lib/rider-theme-pack.jar');
  return execFileSync('unzip', ['-p', jar, 'colorSchemes/RiderIslandsDark.xml'], { encoding: 'utf8', maxBuffer: 1 << 26 });
}

function neovimColors() {
  const dump = fs.mkdtempSync(path.join(os.tmpdir(), 'rider-colors-'));
  const file = path.join(dump, 'colors.json');
  const run = spawnSync('nvim', ['--headless', '-c', `luafile ${path.join(__dirname, 'dump-colors.lua')}`, '-c', 'qa!'],
    { env: { ...process.env, RIDER_COLORS_OUT: file }, encoding: 'utf8', timeout: 60_000 });
  if (!fs.existsSync(file)) fail(`could not read the colours from Neovim: ${run.stderr || run.error}`);
  const data = JSON.parse(fs.readFileSync(file, 'utf8'));
  fs.rmSync(dump, { recursive: true });
  return data;
}

// ---- roles: Rider's colours -> Neovim's colours -----------------------------------------------------------------

const six = (hex) => String(hex).replace(/^#/, '').toLowerCase();

function roles({ palette: p, groups: g }) {
  const fg = (name, fallback) => six(g[name]?.fg ?? fallback);
  const bg = (name, fallback) => six(g[name]?.bg ?? fallback);
  return {
    fg: fg('@variable', p.fg), keyword: fg('@keyword', p.purple), string: fg('@string', p.green), number: fg('@number', p.orange),
    comment: fg('@comment', p.grey), func: fg('@function', p.blue), type: fg('@type', p.yellow), parameter: fg('@variable.parameter', p.fg),
    member: fg('@variable.member', p.cyan), constant: fg('@constant', p.orange), escape: fg('@string.escape', p.red), tag: fg('@tag', p.purple),
    attribute: fg('@attribute', p.cyan), operator: fg('@operator', p.fg), bracket: fg('@punctuation.bracket', p.light_grey),
    error: fg('DiagnosticError', p.red), warn: fg('DiagnosticWarn', p.yellow), info: fg('DiagnosticInfo', p.cyan), hint: fg('DiagnosticHint', p.purple),
    red: six(p.red), orange: six(p.orange), yellow: six(p.yellow), green: six(p.green), cyan: six(p.cyan), blue: six(p.blue), purple: six(p.purple),
    grey: six(p.grey), lightGrey: six(p.light_grey),
    bg0: six(p.bg0), bg1: bg('CursorLine', p.bg1), bg2: six(p.bg2), popup: bg('Pmenu', p.bg1), selection: bg('Visual', p.bg3), reference: bg('LspReferenceText', p.bg2),
    lineNr: fg('LineNr', p.grey), cursorLineNr: fg('CursorLineNr', p.fg),
    diffAdd: bg('DiffAdd', p.diff_add), diffDelete: bg('DiffDelete', p.diff_delete),
    gitAdd: fg('GitSignsAdd', p.green), gitChange: fg('GitSignsChange', p.blue), gitDelete: fg('GitSignsDelete', p.red),
  };
}

// The Rider scheme uses about 30 foreground colours, each for one role. The attribute name tells the cases where one
// colour has two jobs (the green of comments is also the green of "console output green").
function foreground(color, name, r) {
  const console_ = /^(CONSOLE|LOG)_/.test(name);
  switch (color) {
    case 'BDBDBD':
      if (/PARAMETER/.test(name)) return r.parameter;
      if (/BRACES|BRACKETS|PARENTHS|COMMA|DOT|SEMICOLON|BRACE|PAREN/.test(name)) return r.bracket;
      if (/OPERATION_SIGN|OPERATOR/.test(name)) return r.operator;
      return r.fg;
    case 'D0D0D0': case 'F0F0F0': return r.fg;
    case '787878': return r.lightGrey;
    case 'C191FF': return /TAG/.test(name) ? r.tag : name === 'DEFAULT_METADATA' ? r.attribute : r.type;
    case 'E1BFFF': return r.type;
    case '6C95EB': return console_ || /^CODE_VISION/.test(name) ? r.blue : /PROPERTY/.test(name) ? r.member : r.keyword;
    case '39CC9B': return console_ ? r.cyan : r.func;
    case '85C46C': return /COMMENT/.test(name) ? r.comment : console_ ? r.green : r.string;
    case '487D34': return r.comment;
    case 'C9A26D': return /COMMENT/.test(name) ? r.comment : r.string;
    case '66C3CC': return /CONSTANT/.test(name) ? r.constant : r.member;
    case 'ED94C0': return r.number;
    case 'ADEB96': return r.green;
    case 'FFD49E': return /REGEXP/.test(name) ? r.orange : r.escape;
    case 'D688D4': return console_ ? r.purple : r.escape;
    case 'FF5647': case 'E67281': case 'FF919C': return console_ ? r.red : r.error;
    case 'D9B72B': return r.warn;
    case '7DF0C0': return r.cyan;
    case '666666': return r.grey;
    case '7A5C43': case 'FF9259': return r.orange;
    case 'ADD3FF': return r.blue;
    case 'F5D86A': return r.warn;
    case 'FF8870': return r.red;
    case 'FFBFFE': return r.purple;
    default: return null;
  }
}

function background(color, r) {
  return { '191A1C': r.bg0, '232E46': r.reference, '404040': r.bg2, '303030': r.bg1, '343434': r.bg1,
    '612722': r.diffDelete, '4A2421': r.diffDelete, '29421F': r.diffAdd, '21331A': r.diffAdd, '2C4722': r.diffAdd, '2B3427': r.diffAdd }[color] ?? null;
}

function effect(color, r) {
  return { 'FF5647': r.error, '406AC2': r.blue, 'FF9259': r.orange, 'F5D86A': r.warn, '85C46C': r.green, '787878': r.lightGrey,
    '404040': r.grey, '666666': r.grey, '784FB3': r.purple, 'D9B72B': r.warn, '424242': r.grey }[color] ?? null;
}

// the editor-wide colours in the <colors> section
function editorColor(key, value, r) {
  const direct = {
    CARET_ROW_COLOR: r.bg1, SELECTION_BACKGROUND: r.selection, CONSOLE_BACKGROUND_KEY: r.bg0, GUTTER_BACKGROUND: r.bg0,
    DOCUMENTATION_COLOR: r.popup, LOOKUP_COLOR: r.popup, LINE_NUMBERS_COLOR: r.lineNr, LINE_NUMBER_ON_CARET_ROW_COLOR: r.cursorLineNr,
    CARET_COLOR: r.fg, INDENT_GUIDE: r.bg2, METHOD_SEPARATORS_COLOR: r.bg2, RIGHT_MARGIN_COLOR: r.bg2, TEARLINE_COLOR: r.bg2,
    FOLDED_TEXT_BORDER_COLOR: r.bg2, SELECTED_INDENT_GUIDE: r.grey, SELECTED_TEARLINE_COLOR: r.grey, WHITESPACES: r.grey,
    ANNOTATIONS_COLOR: r.lightGrey, ADDED_LINES_COLOR: r.gitAdd, MODIFIED_LINES_COLOR: r.gitChange, DELETED_LINES_COLOR: r.gitDelete,
    READONLY_BACKGROUND: r.bg1, READONLY_FRAGMENT_BACKGROUND: r.bg1, INFORMATION_HINT: r.bg1, ERROR_HINT: r.diffDelete,
  }[key];
  if (direct) return direct;
  if (/^ScrollBar\..*(background|trackColor)$/i.test(key) && six(value) === '383838') return r.bg0;
  return null;
}

// ---- rewrite the scheme -----------------------------------------------------------------------------------------

function build(source, r) {
  const unchanged = new Set();
  let changed = 0;
  const swap = (old, mapped) => {
    if (!mapped) return null;
    changed += 1;
    // keep the notation of the original: some values are written with a leading #, most without
    return old.startsWith('#') ? `#${mapped}` : mapped;
  };

  let text = source.replace(/<scheme name="[^"]*"/, `<scheme name="${NAME}"`)
    .replace('<!-- This document is auto-generated, do not edit manually.-->', `<!-- Generated by make-onedark-scheme.js from the colours of Neovim (${r.fromStyle}). Do not edit; run the script again. -->`);

  text = text.replace(/<colors>([\s\S]*?)<\/colors>/, (whole, inner) => `<colors>${inner.replace(/<option name="([^"]+)" value="([^"]*)"/g,
    (all, key, value) => { const to = value ? swap(value, editorColor(key, value, r)) : null; return to ? `<option name="${key}" value="${to}"` : all; })}</colors>`);

  text = text.replace(/<option name="([^"]+)">(\s*<value>[\s\S]*?<\/value>\s*)<\/option>/g, (whole, name, inner) => {
    let body = inner.replace(/<option name="(FOREGROUND|BACKGROUND|EFFECT_COLOR|ERROR_STRIPE_COLOR)" value="([^"]*)"/g, (all, kind, value) => {
      const color = value.replace(/^#/, '').toUpperCase();
      const mapped = kind === 'FOREGROUND' ? foreground(color, name, r) : kind === 'BACKGROUND' ? background(color, r) : effect(color, r);
      if (!mapped) { if (kind === 'FOREGROUND' && color) unchanged.add(color); return all; }
      return `<option name="${kind}" value="${swap(value, mapped)}"`;
    });
    // constants are not bold in Neovim
    if (name === 'DEFAULT_CONSTANT') body = body.replace(/\s*<option name="FONT_TYPE" value="1" \/>/, '');
    return `<option name="${name}">${body}</option>`;
  });
  return { text, changed, unchanged: [...unchanged].sort() };
}

// ---- install ----------------------------------------------------------------------------------------------------

function configDir() {
  const given = option('--config-dir');
  if (given) return given;
  const base = path.join(os.homedir(), '.config/JetBrains');
  const dirs = fs.existsSync(base) ? fs.readdirSync(base).filter((d) => /^Rider\d/.test(d)).sort() : [];
  if (!dirs.length) fail('no Rider settings folder found in ~/.config/JetBrains; use --config-dir');
  return path.join(base, dirs.at(-1));
}

function install(text) {
  // [r] keeps the pattern from matching the command line that contains it (this script, or the shell that started it)
  const running = spawnSync('pgrep', ['-f', '[r]ider64|JetBrains/Toolbox/apps/[r]ider/']);
  if (running.status === 0) fail('Rider is running. Close it first: it writes its settings back when it closes and would undo this.');
  const dir = configDir();
  fs.mkdirSync(path.join(dir, 'colors'), { recursive: true });
  fs.writeFileSync(path.join(dir, 'colors', `${NAME}.icls`), text);
  const active = path.join(dir, 'options', 'colors.scheme.xml');
  fs.mkdirSync(path.dirname(active), { recursive: true });
  const original = fs.existsSync(active) ? fs.readFileSync(active, 'utf8') : '<application>\n  <component name="EditorColorsManagerImpl">\n    <global_color_scheme name="Rider Islands Dark" />\n  </component>\n</application>\n';
  const backup = `${active}.before-onedark`;
  if (fs.existsSync(active) && !fs.existsSync(backup)) fs.writeFileSync(backup, original);
  fs.writeFileSync(active, original.replace(/<global_color_scheme name="[^"]*"/, `<global_color_scheme name="${NAME}"`));
  console.log(`installed in ${dir}\n  scheme file: colors/${NAME}.icls\n  active scheme: ${NAME} (the old setting is in options/colors.scheme.xml.before-onedark)`);
}

// ---- main -------------------------------------------------------------------------------------------------------

const colors = neovimColors();
const r = { ...roles(colors), fromStyle: `onedark.nvim ${colors.style}` };
const source = bundledScheme();
const { text, changed, unchanged } = build(source, r);

const out = option('--out') ?? path.join(process.cwd(), `${NAME}.icls`);
fs.writeFileSync(out, text);
const lint = spawnSync('xmllint', ['--noout', out], { encoding: 'utf8' });
console.log(`${changed} colours replaced, written to ${out}`);
console.log(lint.error ? 'xmllint not found: well-formedness not checked' : lint.status === 0 ? 'xmllint: well-formed' : `xmllint: ${lint.stderr}`);
if (lint.status) process.exit(1);
if (unchanged.length) console.log(`foreground colours left as Rider has them (no role for them): ${unchanged.map((c) => `#${c}`).join(' ')}`);
if (args.includes('--install')) install(text);
else console.log('not installed (add --install, with Rider closed)');
