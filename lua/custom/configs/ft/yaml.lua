vim.api.nvim_create_autocmd(
  "BufRead", {
    pattern = {"*.yaml", "*.yml"},
    command = "setfiletype yaml"
  }
)
local augroup_yaml = vim.api.nvim_create_augroup(
  "yaml",
  {clear = true}
)
-- Set default YAML formatting options (spaces instead of tabs, etc.)
vim.api.nvim_create_autocmd(
  "FileType", {
    group = augroup_yaml,
    pattern = "yaml",
    command = "setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:>"
  }
)
