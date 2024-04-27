-- Put anything you want to happen only in Neovide here
vim.cmd([[
  let g:neovide_scale_factor = 1.0
  let g:neovide_transparency=0.9

  let g:neovide_floating_blur_amount_x = 2.0
  let g:neovide_floating_blur_amount_y = 2.0

  let g:neovide_cursor_vfx_mode = "railgun"
  set guifont=MonoLisa,JetBrains\ Mono:h13:#e-subpixelantialias
]])

-- Set bufferline bg transparent
vim.cmd([[
  hi TabLine guifg=NONE guibg=NONE
  hi TabLineFill guifg=NONE guibg=NONE
  hi TabLineSel guifg=NONE guibg=NONE
]])

-- Hide non-text from buffers i.e ~ (tilde)
vim.cmd([[ set fillchars=eob:\ ]])

-- Make Float have transparency effect not blend
vim.cmd([[
  hi ErrorFloat guibg=NONE
  hi WarningFloat guibg=NONE
  hi InfoFloat guibg=NONE
  hi HintFloat guibg=NONE
  hi NormalFloat guifg=NONE guibg=NONE
  hi FloatBorder guifg=NONE guibg=NONE
]])

-- disabled annoying bold texthl
vim.cmd([[
  hi WinBar gui=NONE
  hi ErrorMsg gui=NONE
  hi WarningMsg gui=NONE
  hi ModeMsg gui=NONE
  hi MoreMsg gui=NONE
]])

-- disabled annoying neotree bg
vim.cmd([[
  hi NeoTreeNormal guibg=NONE
  hi NeoTreeEndOfBuffer guibg=NONE
  hi NeoTreeFloatTitle guibg=NONE
]])
