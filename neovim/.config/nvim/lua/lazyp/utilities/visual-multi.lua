return {
	"mg979/vim-visual-multi",
	branch = "master",
	init = function()
		vim.cmd([[ 
      let g:multi_cursor_use_default_mapping=0

      " Default mapping
      let g:multi_cursor_start_word_key      = '<C-n>'
      let g:multi_cursor_select_all_word_key = ''
      let g:multi_cursor_start_key           = 'g<C-n>'
      let g:multi_cursor_select_all_key      = ''
      let g:multi_cursor_next_key            = '<C-n>'
      let g:multi_cursor_prev_key            = '<C-p>'
      let g:multi_cursor_skip_key            = '<C-x>'
      let g:multi_cursor_quit_key            = '<Esc>'
    ]])
	end,
}
