---@type ChadrcConfig
local M = {}

if vim.g.vscode then
  M.ui = {
    theme = 'onedark'
  }
  M.plugins = "custom.vscode.plugins"
else
  M.ui = {
    theme = 'onedark',
    nvdash = { load_on_startup = true },
    tabufline = { lazyload = true }
  }
  M.plugins = "custom.chad.plugins"
  M.mappings = require "custom.chad.mappings"
end

vim.opt.clipboard = "unnamedplus"

-- Set clipboard to use win32yank.exe on WSL
-- Make sure to install win32yank.exe on WSL
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
end

function layout_colemak()
  -- Remap l key to enter insert mode in normal mode
  vim.api.nvim_set_keymap('n', 'l', 'i', { noremap = true })
  -- Disable i key for entering insert mode in normal mode
  vim.api.nvim_set_keymap('n', 'i', '<Nop>', { noremap = true })
  -- Define keybindings for 'c' layout
  vim.api.nvim_set_keymap('n', 'n', 'h', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'e', 'j', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'i', 'k', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'o', 'l', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'e', 'gj', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'i', 'gk', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('x', 'e', 'j', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('x', 'i', 'k', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', 'n', 'h', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', 'e', 'j', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', 'i', 'k', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', 'o', 'l', { noremap = true, silent = true })
  -- Remap "j" keys to "o" keys in Colemak layout
  vim.api.nvim_set_keymap('n', 'j', 'o', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'J', 'O', { noremap = true, silent = true })
  -- Remap Search-Forward and Backward Key for Colemak
  vim.api.nvim_set_keymap('n', 'm', 'n', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'M', 'N', { noremap = true, silent = true })
  -- Remap end of word keys for Colemak
  vim.api.nvim_set_keymap('n', 'q', 'e', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'q', 'e', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', 'gq', 'ge', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', 'gq', 'ge', { noremap = true, silent = true })

  _G.set_layout = "c"
  if not vim.g.vscode then
    -- Reload Nvim-Tree to refresh keybinds
    local api = require "nvim-tree.api"
    api.tree.close()
    vim.cmd("NvimTreeToggle")
  end
end

function layout_qwerty()
  -- Define keybindings for 'q' layout
  local bindings = {
    { mode = "n", key = "n" },
    { mode = "n", key = "e" },
    { mode = "n", key = "i" },
    { mode = "n", key = "o" },
    { mode = "n", key = "l" },
    { mode = "n", key = "j" },
    { mode = "n", key = "J" },
    { mode = "n", key = "m" },
    { mode = "n", key = "M" },
    { mode = "n", key = "q" },
    { mode = "n", key = "gq" },
  }
  -- Iterate over the list of dictionaries
  for _, dictionary in ipairs(bindings) do
    local success, result = pcall(function()
      vim.api.nvim_del_keymap(dictionary["mode"], dictionary["key"])
    end)
  end
  _G.set_layout = "q"
  if not vim.g.vscode then
    -- Reload Nvim-Tree to refresh keybinds
    local api = require "nvim-tree.api"
    api.tree.close()
    vim.cmd("NvimTreeToggle")
  end
end

vim.defer_fn(layout_colemak, 0)

-- Define a Lua function to change keybindings
_G.setLayout = function(layout)
  if layout == 'q' then
    layout_qwerty()
  elseif layout == 'c' then
    layout_colemak()
  else
     print('Invalid layout. Available options are: q, c')
  end
end

-- Map the Lua function to a custom command
vim.cmd([[command! -nargs=1 SetLayout lua setLayout(<f-args>)]])

return M
