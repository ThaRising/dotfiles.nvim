local augroup_make = vim.api.nvim_create_augroup(
  "make",
  {clear = true}
)
-- Format all double whitespaces at the start of a line to Tabs
vim.api.nvim_create_autocmd(
  "BufWritePre", {
    group = augroup_make,
    pattern = "Makefile*",
    command = ":keepp silent! %s/^  /\t/g"
  }
)
-- Set default formatting optinos for Make (use tabs instead of spaces)
vim.api.nvim_create_autocmd(
  "FileType", {
    group = augroup_make,
    pattern = "Makefile*",
    command = "set noexpandtab shiftwidth=8 softtabstop=0"
  }
)
