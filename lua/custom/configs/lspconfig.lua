local config = require "plugins.configs.lspconfig"

local on_attach = config.on_attach
local capabilities = config.capabilities

local lspconfig = require "lspconfig"

-- Python
-- Disable Hints (purple text, with a light-bulb icon that cannot be silenced using pyright ignore comments)
capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "python" },
}

-- Terraform
-- Warning: This requires 'terraform-ls' to be installed on your system
lspconfig.terraformls.setup {}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

vim.api.nvim_exec(
  [[
  augroup terraformvars
    autocmd!
    autocmd BufRead,BufNewFile *.tfvars set filetype=terraform
  augroup END
]],
  false
)
