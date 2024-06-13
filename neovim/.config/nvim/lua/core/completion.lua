local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

local buffer_fts = {
	"markdown",
	"toml",
	"yaml",
	"json",
}

local function contains(t, value)
	for _, v in pairs(t) do
		if v == value then
			return true
		end
	end
	return false
end

local compare = require("cmp.config.compare")

require("luasnip/loaders/from_vscode").lazy_load()

-- local check_backspace = function()
-- 	local col = vim.fn.col(".") - 1
-- 	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
-- end

local check_backspace = function()
	local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local icons = require("utils.icons")

local kind_icons = icons.kind

-- find more here: https://www.nerdfonts.com/cheat-sheet

-- vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
vim.api.nvim_set_hl(0, "CmpItemKindTabnine", { fg = "#CA42F0" })
-- vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })
vim.api.nvim_set_hl(0, "CmpItemKindCrate", { fg = "#F64D00" })

-- vim.g.cmp_active = true

cmp.setup({
	enabled = function()
		-- disable completion in comments
		local context = require("cmp.config.context")
		-- buftype
		local buftype = vim.api.nvim_buf_get_option(0, "buftype")

		if buftype == "prompt" then
			return false
		end

		if not vim.api.nvim_get_mode().mode == "c" then
			return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
		end

		-- keep command mode completion enabled when cursor is in a comment
		return vim.g.cmp_active or true
	end,
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif check_backspace() then
				fallback()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])

			-- if entry.source.name == "cmp_tabnine" then
			-- 	vim_item.kind = icons.misc.Robot
			-- 	vim_item.kind_hl_group = "CmpItemKindTabnine"
			-- end

			if entry.source.name == "crates" then
				vim_item.kind = icons.misc.Package
				vim_item.kind_hl_group = "CmpItemKindCrate"
			end

			-- vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind

			vim_item.abbr = string.sub(vim_item.abbr, 1, 25)

			vim_item.menu = ({
				nvim_lsp = "⌞LSP⌝",
				nvim_lua = "⌞Lua⌝",
				luasnip = "⌞luasnip⌝",
				buffer = "⌞Buffer⌝",
				-- cmp_tabnine = "⌞TN⌝",
				path = "⌞Path⌝",
			})[entry.source.name]

			vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)

			return vim_item
		end,
	},
	sources = {
		{ name = "crates", group_index = 1 },
		{
			name = "nvim_lsp",
			filter = function(entry, _)
				local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
				if kind == "Snippet" then
					return true
				end

				if kind == "Text" then
					return true
				end
			end,
			group_index = 2,
		},
		{ name = "nvim_lua", group_index = 2 },
		{ name = "luasnip", group_index = 2 },
		{
			name = "buffer",
			group_index = 2,
			filter = function(_, ctx)
				if not contains(buffer_fts, ctx.prev_context.filetype) then
					return true
				end
			end,
		},
		{
			name = "lazydev",
			group_index = 0, -- set group index to 0 to skip loading LuaLS completions
		},
		{ name = "path", group_index = 2 },
	},
	sorting = {
		priority_weight = 2,
		comparators = {
			-- require("copilot_cmp.comparators").prioritize,
			-- require("copilot_cmp.comparators").score,
			compare.offset,
			compare.exact,
			-- compare.scopes,
			compare.score,
			compare.recently_used,
			compare.locality,
			-- compare.kind,
			compare.sort_text,
			compare.length,
			compare.order,
			-- require("copilot_cmp.comparators").prioritize,
			-- require("copilot_cmp.comparators").score,
		},
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	window = {
		-- if you want transparent background for completion and documentation set winhighlight
		documentation = {
			border = icons.ui.Border_Single_Line,
			winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
		},
		completion = {
			border = icons.ui.Border_Single_Line,
			winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
		},
	},
	experimental = {
		ghost_text = false,
	},
})

-- `/` cmdline setup.
-- cmp.setup.cmdline({ "/", "?" }, {
-- 	mapping = cmp.mapping.preset.cmdline(),
-- 	sources = {
-- 		{ name = "buffer" },
-- 	},
-- })

-- `:` cmdline setup.
-- cmp.setup.cmdline(":", {
-- 	mapping = cmp.mapping.preset.cmdline(),
-- 	sources = cmp.config.sources({
-- 		{ name = "path" },
-- 	}, {
-- 		{
-- 			name = "cmdline",
-- 			option = {
-- 				ignore_cmds = { "Man", "!" },
-- 			},
-- 		},
-- 	}),
-- })
