require('auto-session').setup({
  auto_restore = true,
  auto_restore_last_session = false,
  auto_save = true,
  enabled = true,
  log_level = "error",
  root_dir = vim.fn.stdpath("data") .. "/sessions/",
  session_lens = {
    load_on_setup = true,
    picker_opts = {
      border = true
    },
    previewer = false
  }
})

