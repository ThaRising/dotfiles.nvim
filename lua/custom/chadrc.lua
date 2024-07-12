---@type ChadrcConfig
local M = {}

if vim.g.vscode then
  M.ui = {
    theme = "onedark",
  }
  M.plugins = "custom.vscode.plugins"
  M.mappings = require "custom.vscode.mappings"
else
  M.ui = {
    theme = "onedark",
    tabufline = { lazyload = true },
    statusline = {
      overriden_modules = function(modules)
        local function stbufnr()
          return vim.api.nvim_win_get_buf(vim.g.statusline_winid)
        end

        modules[2] = (function()
          local icon = " 󰈚 "
          local path = vim.api.nvim_buf_get_name(stbufnr())
          local name = (path == "" and "Empty ") or path:match "([^/\\]+)[/\\]*$"

          if name ~= "Empty " then
            local devicons_present, devicons = pcall(require, "nvim-web-devicons")

            if devicons_present then
              local ft_icon = devicons.get_icon(name)
              icon = (ft_icon ~= nil and " " .. ft_icon) or icon
            end

            name = vim.fn.fnamemodify(path, ":.")
            name = " " .. name .. " "
          end

          return "%#St_file_info#" .. icon .. name .. "%#St_file_sep#" .. ""
        end)()

        table.insert(
          modules,
          3,
          (function()
            local branchname = vim.fn.system "git rev-parse --abbrev-ref HEAD"
            branchname = branchname:gsub("[^%w-_]", "")
            if branchname ~= "HEAD" then
              local number_of_commits = vim.fn.system("git rev-list HEAD...origin/" .. branchname .. " --count")
              number_of_commits = number_of_commits:gsub("%D", "")
              if number_of_commits == "0" then
                number_of_commits = "~" .. number_of_commits
              else
                number_of_commits = "+" .. number_of_commits
              end
              return "%#St_commitnr_info#" .. " " .. number_of_commits .. "%#St_commitnr_sep#"
            else
              return "%#St_commitnr_info#" .. " ~" .. "%#St_commitnr_sep#"
            end
          end)()
        )
        table.insert(
          modules,
          3,
          (function()
            return " " .. vim.bo.filetype
          end)()
        )
      end,
    },
  }
  if vim.fn.has "wsl" ~= 1 then
    M.ui.nvdash = { load_on_startup = true }
  end
  M.plugins = "custom.chad.plugins"
  M.mappings = require "custom.chad.mappings"
end

if vim.fn.has "wsl" == 1 then
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

function layout_colemak(called_by_user)
  called_by_user = called_by_user or false
  -- Remap l key to enter insert mode in normal mode
  vim.api.nvim_set_keymap("n", "l", "i", { noremap = true })
  -- Disable i key for entering insert mode in normal mode
  vim.api.nvim_set_keymap("n", "i", "<Nop>", { noremap = true })
  -- Define keybindings for 'c' layout
  vim.api.nvim_set_keymap("n", "n", "h", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "e", "j", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "i", "k", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "o", "l", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "e", "gj", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "i", "gk", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("x", "e", "j", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("x", "i", "k", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "n", "h", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "e", "j", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "i", "k", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "o", "l", { noremap = true, silent = true })
  -- Remap "j" keys to "o" keys in Colemak layout
  vim.api.nvim_set_keymap("n", "j", "o", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "J", "O", { noremap = true, silent = true })
  -- Remap Search-Forward and Backward Key for Colemak
  vim.api.nvim_set_keymap("n", "m", "n", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "M", "N", { noremap = true, silent = true })
  -- Remap end of word keys for Colemak
  vim.api.nvim_set_keymap("n", "k", "e", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "k", "e", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("o", "k", "e", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "K", "E", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "K", "E", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("o", "K", "E", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "gk", "ge", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "gk", "ge", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "ck", "ce", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "cK", "cE", { noremap = true, silent = true })

  _G.set_layout = "c"
  if not vim.g.vscode then
    -- Reload Nvim-Tree only if it was open before
    local tree = require "nvim-tree.view"
    if tree.is_visible() and called_by_user then
      -- Reload Nvim-Tree to refresh keybinds
      local api = require "nvim-tree.api"
      api.tree.close()
      vim.cmd "NvimTreeToggle"
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
      vim.cmd "NvimTreeToggle"
    end
  end
end

vim.defer_fn(layout_colemak, 0)

-- Define a Lua function to change keybindings
_G.setLayout = function(layout)
  if layout == "q" then
    layout_qwerty(true)
  elseif layout == "c" then
    layout_colemak(true)
  else
    print "Invalid layout. Available options are: q, c"
  end
end

-- Map the Lua function to a custom command
vim.cmd [[command! -nargs=1 SetLayout lua setLayout(<f-args>)]]

_G.surround = function(character)
  character = character or "\\ "
  vim.cmd(string.format('execute "normal! ciw%s%s\\eP"', character, character))
end

vim.cmd [[command! -nargs=? Wrap lua surround(<f-args>)]]
vim.cmd [[command! -nargs=? W lua surround(<f-args>)]]

function read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local content = file:read "*a"
  file:close()
  return content
end

_G.ansible_vault_encrypt = function()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_file_path = vim.api.nvim_buf_get_name(current_buf)
  local file_content = read_file(current_file_path)
  local vault_identifier = "$ANSIBLE_VAULT;"
  vim.cmd "write"
  if file_content:sub(1, #vault_identifier) == vault_identifier then
    vim.fn.system(
      string.format(
        "ansible-vault decrypt --vault-password-file ~/ansiblevaultpw --output %s %s",
        current_file_path,
        current_file_path
      )
    )
  else
    vim.fn.system(
      string.format(
        "ansible-vault encrypt --vault-password-file ~/ansiblevaultpw --output %s %s",
        current_file_path,
        current_file_path
      )
    )
  end
  vim.cmd "checktime"
end

_G.terminal_cwd = function()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_file_path = vim.api.nvim_buf_get_name(current_buf)
  local current_file_cwd = current_file_path:match "(.-)[^/]+$"
  require("nvterm.terminal").toggle "float"
  require("nvterm.terminal").send(string.format("cd %s", current_file_cwd), "float")
  require("nvterm.terminal").toggle "float"
  require("nvterm.terminal").toggle "float"
end

_G.terminal_cwd_to_project_root = function()
  local project_basedir = vim.fn.getcwd()
  require("nvterm.terminal").toggle "float"
  require("nvterm.terminal").send(string.format("cd %s", project_basedir), "float")
  require("nvterm.terminal").toggle "float"
  require("nvterm.terminal").toggle "float"
end

_G.close_all_buffers = function()
  local buffers = vim.api.nvim_list_bufs()
  local current_buffer = vim.api.nvim_buf_get_name(0)
  for _, buf in ipairs(buffers) do
    local buffer_name = vim.api.nvim_buf_get_name(buf)
    if buffer_name == current_buffer then
      goto continue
    end
    if not (buffer_name:find "^term" or buffer_name:find "NvimTree") then
      if vim.api.nvim_buf_get_option(buf, "modified") then
        vim.api.nvim_echo({ { "Unsaved changes, aborting operation", "White" } }, true, {})
        return
      end
      vim.api.nvim_buf_delete(buf, { force = true })
    end
    ::continue::
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.fn.jobstart "git fetch --all"
  end,
})

-- General Formatting
local augroup_spacefix = vim.api.nvim_create_augroup("SpaceFix", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePre" }, {
  group = augroup_spacefix,
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "make" or vim.bo.filetype == "markdown" then
      return
    end
    vim.cmd ":keepp silent %s/\\s\\+$//ge | :keepp silent %s/\\t/  /ge"
  end,
})
-- YAML
require "custom.configs.ft.yaml"
-- Make
require "custom.configs.ft.make"

vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function()
    require("cmp").setup.buffer {
      enabled = false,
    }
  end,
})

vim.cmd "set history=10000"

vim.opt.showbreak = "↪\\"
vim.opt.listchars = {
  tab = "→\\ ",
  eol = "↲",
  nbsp = "␣",
  trail = "•",
  extends = "⟩",
  precedes = "⟨",
}
vim.opt.list = true
-- auto-reload files when modified externally
-- https://unix.stackexchange.com/a/383044
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- Function search for selected
function _G.search_selected_text()
  local old_reg = vim.fn.getreg '"'
  vim.cmd "normal! gvy"
  local selected_text = vim.fn.getreg '"'
  vim.fn.setreg('"', old_reg)
  vim.cmd("/" .. vim.fn.escape(selected_text, "\\/"))
end

return M
