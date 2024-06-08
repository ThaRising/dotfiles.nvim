local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  if not vim.g.vscode and _G.set_layout == "c" then
    -- Define custom mappings for nvim-tree.lua
    local custom_mappings = {
      { op = "unset", key = 'e' },
      { op = "unset", key = 'i' },
      { op = "unset", key = 'j' },
      { op = "unset", key = 'n' },
      { op = "unset", key = 'N' },
      { op = "unset", key = 'O' },
      { op = "set",   key = 'n', cb = api.node.navigate.parent_close, desc = "Close Directory" },
      { op = "set",   key = 'N', cb = api.tree.collapse_all,          desc = "Collapse" },
      { op = "set",   key = 'j', cb = api.fs.rename_basename,         desc = "Rename: Basename" },
      { op = "set",   key = 'O', cb = api.tree.expand_all,            desc = "Expand All" },
    }
    -- Apply the custom key mappings
    for _, mapping in ipairs(custom_mappings) do
      if mapping.op == "set" then
        vim.keymap.set("n", mapping.key, mapping.cb, opts(mapping.desc))
      elseif mapping.op == "unset" then
        local success, result = pcall(function()
          vim.keymap.del("n", mapping.key, { buffer = bufnr })
        end)
      end
    end
  end
end

local options = require "plugins.configs.nvimtree"
options.on_attach = my_on_attach
options.git.enable = true
options.git.ignore = false
options.renderer.highlight_git = "all"
return options
