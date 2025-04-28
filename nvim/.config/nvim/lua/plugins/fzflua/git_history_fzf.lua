local M = {}
local fzf_lua = require("fzf-lua")

-- Check if in Git repo by looking for .git folder upwards
local function in_git_repo()
	local git_dir = vim.fs.find(".git", { upward = true })[1]
	return git_dir ~= nil
end

-- Check if git is available on the system
local function git_installed()
	return vim.fn.executable("git") == 1
end

-- Default RG options (with exclusions for node_modules/.git/.cache)
local rg_opts =
	"--hidden --column --line-number --no-heading --color=always --smart-case -g '!node_modules/*' -g '!*.git/*' -g '!*.cache/*'"

M.live_git_search = function()
	-- Check if in a git repo and if git is installed
	if in_git_repo() and git_installed() then
		-- Use advanced git grep with custom preview
		fzf_lua.fzf_live("git rev-list --all | xargs git grep --line-number --column --color=always <query>", {
			prompt = "GitHistoryGrep❯ ",
			fzf_opts = {
				["--delimiter"] = ":",
				["--no-exit-0"] = "",
				["--preview-window"] = "nohidden,up,60%,border-bottom,+{3}+3/3,~3",
			},
			preview = [[
        (echo "Commit: {1}";
         git show -s --format="Date: %cd" --date=format:"%b %d, %Y %I:%M %p" {1};
         echo "";
         git show {1}:{2}
        ) | bat --style=default --color=always --file-name={2} --highlight-line={3}
      ]],
			actions = {
				["default"] = function(selected)
					if not selected or not selected[1] then
						return
					end

					local entry = selected[1]
					local parts = vim.split(entry, ":")

					local filepath = parts[1] or ""
					local linenr = tonumber(parts[2]) or 1
					local colnr = tonumber(parts[3]) or 1

					if filepath == "" then
						vim.notify("Invalid selection: no file path", vim.log.levels.WARN)
						return
					end

					-- Check if the file exists
					if vim.fn.filereadable(filepath) == 1 then
						-- If the file exists, open it and close the FZF window
						vim.cmd("edit " .. vim.fn.fnameescape(filepath))
						vim.schedule(function()
							pcall(vim.api.nvim_win_set_cursor, 0, { linenr, math.max(colnr - 1, 0) })
						end)

						-- Close the FZF window after file is opened
						vim.api.nvim_set_current_win(0) -- Ensure we're in the correct window
						vim.api.nvim_win_close(0, true)
					end

					vim.notify("File not found: " .. filepath, vim.log.levels.WARN)
					-- Keep the FZF window open and do NOT clear it
					fzf_lua.resume()
				end,
			},
		})
	elseif git_installed() then
		-- Not in git repo? Use ripgrep
		fzf_lua.live_grep({
			prompt = "Ripgrep❯ ",
			rg_opts = rg_opts,
			actions = {
				["default"] = function(selected)
					-- Open file and jump to the line after selection in ripgrep results
					local filename, lnum = selected[1], tonumber(selected[2])
					if filename and lnum then
						vim.cmd(string.format("edit %s", filename))
						vim.api.nvim_win_set_cursor(0, { lnum, 0 })
					end
				end,
			},
		})
	else
		-- If no git and git is not available, show a message
		vim.notify("Git is not installed or not in a Git repository", vim.log.levels.WARN)
	end
end

return M
