local autosession = require("auto-session")

local function refresh_nvim_tree()
  local api = require('nvim-tree.api')
  _G.setLayout("c")
  api.tree.close()
  api.tree.open()
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    local bufname = vim.api.nvim_buf_get_name(buf)
    if not string.find(bufname, "NvimTree_") and bufname ~= "" then
      vim.cmd("e#")
      break
    end
  end
end

autosession.setup {
  log_level = "error",
  auto_session_suppress_dirs = { "~/", "~/Downloads", "/"},
  post_restore_cmds = {refresh_nvim_tree}
}
