return {
  "rmagatti/auto-session",
  config = function ()
    local status_ok, auto_session = pcall(require, "auto-session")
    if not status_ok then
      return
    end

    local opts = {
      log_level = "info",
      auto_session_enable_last_session = false,
      auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
      auto_session_enabled = true,
      auto_save_enabled = nil,
      auto_session_pre_save_cmds = { "tabdo NeoTreeClose" },
      auto_restore_enabled = nil,
      auto_session_suppress_dirs = { os.getenv("HOME") },
      auto_session_use_git_branch = nil,
      -- the configs below are lua onlqy
      bypass_session_save_file_types = { "alpha" },
      session_lens = {
        path_display = { "shorten" },
        theme_conf = { border = true },
        previewer = false,
        prompt_title = "Sessions",
      },
    }

    vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

    auto_session.setup(opts)
  end
}

