---@type ChadrcConfig
local M = {}

if vim.g.vscode then
  M.ui = {
    theme = 'onedark'
  }
  M.plugins = "custom.vscode.plugins"
  M.mappings = require "custom.vscode.mappings"
else
  M.ui = {
    theme = 'onedark',
    tabufline = { lazyload = true }
  }
  if vim.fn.has("wsl") ~= 1 then
    M.ui.nvdash = { load_on_startup = true }
  end
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

function layout_colemak(called_by_user)
  called_by_user = called_by_user or false
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
  vim.api.nvim_set_keymap('v', 'q', 'e', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('o', 'q', 'e', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', 'gq', 'ge', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', 'gq', 'ge', { noremap = true, silent = true })

  _G.set_layout = "c"
  if not vim.g.vscode then
    -- Reload Nvim-Tree only if it was open before
    local tree = require "nvim-tree.view"
    if tree.is_visible() and called_by_user then
      -- Reload Nvim-Tree to refresh keybinds
      local api = require "nvim-tree.api"
      api.tree.close()
      vim.cmd("NvimTreeToggle")
    end
  end
end

function layout_qwerty(called_by_user)
  called_by_user = called_by_user or false
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

  _G.set_layout = "c"
  if not vim.g.vscode then
    -- Reload Nvim-Tree only if it was open before
    local tree = require "nvim-tree.view"
    if tree.is_visible() and called_by_user then
      -- Reload Nvim-Tree to refresh keybinds
      local api = require "nvim-tree.api"
      api.tree.close()
      vim.cmd("NvimTreeToggle")
    end
  end
end

vim.defer_fn(layout_colemak, 0)

-- Define a Lua function to change keybindings
_G.setLayout = function(layout)
  if layout == 'q' then
    layout_qwerty(true)
  elseif layout == 'c' then
    layout_colemak(true)
  else
     print('Invalid layout. Available options are: q, c')
  end
end

-- Map the Lua function to a custom command
vim.cmd([[command! -nargs=1 SetLayout lua setLayout(<f-args>)]])

_G.surround = function (character)
  character = character or "\\ "
  vim.cmd(string.format('execute "normal! ciw%s%s\\eP"', character, character))
end

vim.cmd([[command! -nargs=? Wrap lua surround(<f-args>)]])
vim.cmd([[command! -nargs=? W lua surround(<f-args>)]])

function read_file(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*a")
    file:close()
    return content
end

_G.ansible_vault_encrypt = function ()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_file_path = vim.api.nvim_buf_get_name(current_buf)
  local file_content = read_file(current_file_path)
  local vault_identifier = "$ANSIBLE_VAULT;"
  vim.cmd('write')
  if file_content:sub(1, #vault_identifier) == vault_identifier then
    vim.fn.system(string.format("ansible-vault decrypt --vault-password-file ~/ansiblevaultpw --output %s %s", current_file_path, current_file_path))
  else
    vim.fn.system(string.format("ansible-vault encrypt --vault-password-file ~/ansiblevaultpw --output %s %s", current_file_path, current_file_path))
  end
  vim.cmd('checktime')
end

_G.terminal_cwd = function ()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_file_path = vim.api.nvim_buf_get_name(current_buf)
  local current_file_cwd = current_file_path:match("(.-)[^/]+$")
  require("nvterm.terminal").toggle "float"
  require("nvterm.terminal").send(string.format("cd %s", current_file_cwd), "float")
  require("nvterm.terminal").toggle "float"
  require("nvterm.terminal").toggle "float"
end

local timer = vim.loop.new_timer()
timer:start(2000, 30000, vim.schedule_wrap(function()
  timer:stop()
  vim.fn.system("git fetch")
end))

return M
