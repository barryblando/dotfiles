-- https://github.com/microsoft/vscode/blob/main/src/vs/base/common/codicons.ts
-- go to the above and then enter <c-v>u<unicode> and the symbold should appear
-- or go here and upload the font file: https://mathew-kurian.github.io/CharacterMap/
-- find more here: https://www.nerdfonts.com/cheat-sheet
vim.g.use_nerd_icons = false
if vim.fn.has("mac") == 1 or vim.g.use_nerd_icons then
	-- elseif vim.fn.has "mac" == 1 then
	return {
		kind = {
			Text = " ",
			Method = " ",
			Function = " ",
			Constructor = " ",
			Field = " ",
			Variable = " ",
			Class = " ",
			Interface = " ",
			Module = " ",
			Property = " ",
			Unit = " ",
			Value = " ",
			Enum = " ",
			Keyword = " ",
			Snippet = " ",
			Color = " ",
			File = " ",
			Reference = " ",
			Folder = " ",
			EnumMember = " ",
			Constant = " ",
			Struct = " ",
			Event = " ",
			Operator = " ",
			TypeParameter = " ",
			Misc = " ",
		},
		type = {
			Array = " ",
			Number = " ",
			String = " ",
			Boolean = " ",
			Object = " ",
			Null = "󰟢 ",
		},
		documents = {
			File = " ",
			Files = " ",
			Folder = " ",
			OpenFolder = " ",
		},
		git = {
			Add = " ",
			Mod = " ",
			Remove = " ",
			Ignore = " ",
			Rename = " ",
			Diff = " ",
			Repo = " ",
		},
		gitsigns = {
			GitSignsAdd = "▎",
			GitSignsChange = "▎",
			GitSignsChangeDelete = "▎",
			GitSignsDelete = " ",
			GitSignsTopDelete = " ",
		},
		ui = {
			ArrowClosed = "",
			ArrowOpen = "",
			Lock = " ",
			Circle = "",
			BigCircle = "",
			BigUnfilledCircle = "",
			Close = " ",
			NewFile = " ",
			Search = " ",
			Lightbulb = " ",
			Project = " ",
			Dashboard = " ",
			History = " ",
			Comment = " ",
			Bug = " ",
			Code = " ",
			Telescope = " ",
			Gear = " ",
			Package = " ",
			List = " ",
			SignIn = " ",
			SignOut = " ",
			Check = " ",
			Fire = " ",
			Note = "󰎚 ",
			BookMark = " ",
			Pencil = " ",
			-- ChevronRight = "",
			ChevronRight = ">",
			Table = " ",
			Calendar = " ",
			CloudDownload = " ",
		},
		diagnostics = {
			Error = " ",
			Warning = " ",
			Information = " ",
			Question = " ",
			Hint = "y ",
		},
		misc = {
			Robot = "󰚩 ",
			Squirrel = " ",
			Tag = " ",
			Watch = " ",
		},
	}
else
	return {
		kind = {
			Text = " ",
			Method = " ",
			Function = " ",
			Constructor = " ",
			Field = " ",
			Variable = " ",
			Class = " ",
			Interface = " ",
			Module = " ",
			Property = " ",
			Unit = " ",
			Value = " ",
			Enum = " ",
			Keyword = " ",
			Snippet = " ",
			Color = " ",
			File = " ",
			Reference = " ",
			Folder = " ",
			EnumMember = " ",
			Constant = " ",
			Struct = " ",
			Event = " ",
			Operator = " ",
			TypeParameter = " ",
			Misc = " ",
		},
		type = {
			Array = " ",
			Number = " ",
			String = " ",
			Boolean = " ",
			Object = " ",
			Null = "󰟢 ",
		},
		documents = {
			File = " ",
			Files = " ",
			Folder = " ",
			OpenFolder = " ",
		},
		git = {
			Add = " ",
			Mod = " ",
			Remove = " ",
			Ignore = " ",
			Rename = " ",
			Diff = " ",
			Repo = " ",
		},
		gitsigns = {
			GitSignsAdd = "│",
			GitSignsChange = "│",
			GitSignsChangeDelete = "│",
			GitSignsUntracked = "┆",
			GitSignsDelete = "",
			GitSignsTopDelete = "",
			-- GitSignsAdd = "▎",
			-- GitSignsChange = "▎",
			-- GitSignsChangeDelete = "▎",
			-- GitSignsDelete = " ",
			-- GitSignsTopDelete = " ",
		},
		ui = {
			ArrowClosed = "",
			ArrowOpen = "",
			Lock = " ",
			Circle = " ",
			BigCircle = " ",
			BigUnfilledCircle = " ",
			Close = " ",
			NewFile = " ",
			Search = " ",
			Lightbulb = " ",
			Project = " ",
			Dashboard = " ",
			History = " ",
			Comment = " ",
			Bug = " ",
			Code = " ",
			Telescope = " ",
			Gear = " ",
			Package = " ",
			List = " ",
			SignIn = " ",
			SignOut = " ",
			NoteBook = " ",
			Check = " ",
			Fire = " ",
			Note = " ",
			BookMark = " ",
			Pencil = " ",
			ChevronRight = "",
			ChevronLeft = "",
			Table = " ",
			Calendar = " ",
			CloudDownload = " ",
			TriangleRight = "",
			TriangleLeft = "",
			Border_Single_Line = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
			Border_Solid_Line = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
			Border_Double_Line = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
			Border_Chars_Single_Line = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			Border_Chars = {
				{ "─", "│", "─", "│", "┌", "┐", "┘", "└" },
				prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
				results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
				preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			},
		},
		diagnostics = {
			Error = " ",
			Warning = " ",
			Information = " ",
			Question = " ",
			Hint = " ",
		},
		diagnostics_alt = {
			Error = "",
			Warning = "",
			Information = "󰙎",
			Question = "",
			Hint = "󰛨 ",
		},
		misc = {
			Robot = " ",
			Squirrel = " ",
			Tag = " ",
			Watch = " ",
		},
	}
end
