vim.cmd("highlight clear")
vim.o.background = "dark"
vim.g.colors_name = "eveninarcadia"

local colors = {
  bg       = "#0a120c",  -- dark background
  fg       = "#A7A8AC",  -- light gray
  accent1  = "#AC2F52",  -- rose red
  accent2  = "#8A3663",  -- plum
  gray     = "#49494D",  -- dark gray
}


vim.api.nvim_set_hl(0, "Normal",        { fg = colors.fg, bg = colors.bg })
vim.api.nvim_set_hl(0, "Comment",       { fg = colors.gray, italic = true })
vim.api.nvim_set_hl(0, "Constant",      { fg = colors.accent2 })
vim.api.nvim_set_hl(0, "String",        { fg = colors.accent1 })
vim.api.nvim_set_hl(0, "Function",      { fg = colors.accent2 })
vim.api.nvim_set_hl(0, "Identifier",    { fg = colors.accent1 })
vim.api.nvim_set_hl(0, "Statement",     { fg = colors.accent1, bold = true })
vim.api.nvim_set_hl(0, "PreProc",       { fg = colors.accent2 })
vim.api.nvim_set_hl(0, "Type",          { fg = colors.fg })
vim.api.nvim_set_hl(0, "Special",       { fg = colors.accent2 })
vim.api.nvim_set_hl(0, "Todo",          { fg = colors.accent1, bg = colors.bg, bold = true })

-- Basic UI
vim.api.nvim_set_hl(0, "LineNr",        { fg = colors.gray })
vim.api.nvim_set_hl(0, "CursorLineNr",  { fg = colors.accent1, bold = true })
vim.api.nvim_set_hl(0, "VertSplit",     { fg = colors.gray })
vim.api.nvim_set_hl(0, "StatusLine",    { fg = colors.fg, bg = colors.gray })
vim.api.nvim_set_hl(0, "Pmenu",         { fg = colors.fg, bg = colors.gray })

return {}
