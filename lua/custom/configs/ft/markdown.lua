vim.api.nvim_create_autocmd("BufRead", {
  pattern = { "*.md", "*.rst" },
  command = "setfiletype markdown",
})
local augroup_yaml = vim.api.nvim_create_augroup("markdown", { clear = true })
-- Set default Markdown formatting options (spaces instead of tabs, etc.)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup_yaml,
  pattern = "markdown",
  command = "setlocal ts=2 sts=2 sw=2 expandtab",
})
