local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require('null-ls')

local opts = {
  sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort.with({
      args = {"--stdout", "-sl", "--filename", "$FILENAME", "-"}
    }),
    null_ls.builtins.formatting.ruff,
    null_ls.builtins.formatting.isort.with({
      args = {"--stdout", "-m", "3", "--filename", "$FILENAME", "-"}
    }),
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.djlint,
    null_ls.builtins.diagnostics.mypy,
    null_ls.builtins.diagnostics.ruff,
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = bufnr,
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
}
return opts

