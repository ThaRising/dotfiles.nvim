local M = {}

function M.setup()
  vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#B8CC52", bg = "#373D29" })
  vim.api.nvim_set_hl(0, "DiffChange", { fg = "#68A8E4", bg = "#2B3B4A" })
  vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#F07178", bg = "#432937" })
  vim.api.nvim_set_hl(0, "DiffText", { fg = "#FFCC66", bg = "#684C23" })
end

return M
