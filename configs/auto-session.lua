local autosession = require("auto-session")

local function refresh_nvim_tree()
  local api = require('nvim-tree.api')
  api.tree.open()
  vim.cmd("e#")
end

autosession.setup {
  log_level = "error",
  auto_session_suppress_dirs = { "~/", "~/Downloads", "/"},
  post_restore_cmds = {refresh_nvim_tree}
}
