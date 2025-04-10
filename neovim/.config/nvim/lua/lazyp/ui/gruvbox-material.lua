return {
	"sainnhe/gruvbox-material",
	lazy = false,
	priority = 1000,
	init = function()
		-- load the colorscheme here
		vim.cmd([[
        " Important!! https://github.com/sainnhe/gruvbox-material/blob/master/doc/gruvbox-material.txt
        " if has('termguicolors')
        " set termguicolors
        " endif

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
	end,
}
