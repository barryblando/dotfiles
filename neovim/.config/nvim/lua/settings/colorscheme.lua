local colorscheme = "gruvbox-material"
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not status_ok then
	vim.notify(
		colorscheme
			.. " not detected on first boot. Restart Neovim after all plugins are installed. Ignore this message. Thank you!",
		"info",
		{
			title = "ColorScheme",
		}
	)
	return
end

-- Gruvbox Config
vim.cmd([[
  " Important!! https://github.com/sainnhe/gruvbox-material/blob/master/doc/gruvbox-material.txt
  if has('termguicolors')
    set termguicolors
  endif

  " For dark version.
  set background=dark
   
  " This configuration option should be placed before `colorscheme gruvbox-material`.
  " Available values: 'hard', 'medium'(default), 'soft'
  let g:gruvbox_material_background = 'hard'

  let g:gruvbox_material_foreground = 'mix'

  let g:gruvbox_material_transparent_background = 1
  
  " For better performance
  let g:gruvbox_material_better_performance = 1

  let g:gruvbox_material_enable_italic = 1
  
  colorscheme gruvbox-material
]])

-- Set bufferline bg transparent
vim.cmd([[ highlight TabLineFill guibg=NONE ]])

-- Hide non-text from buffers i.e ~ (tilde)
vim.cmd([[ set fillchars=eob:\ ]])

-- Set statusline in nvim_tree transparent
vim.cmd([[
  hi StatusLine gui=NONE guibg=NonText guisp=NonText
  hi StatusLineNc gui=NONE guibg=NonText guisp=NonText
]])

-- Make Float have transparency effect not blend
vim.cmd([[
  hi ErrorFloat guibg=NONE
  hi WarningFloat guibg=NONE
  hi InfoFloat guibg=NONE
  hi HintFloat guibg=NONE
  hi NormalFloat guifg=NONE guibg=NONE
  hi FloatBorder guifg=NONE guibg=NONE
  hi WinBar gui=NONE
]])
