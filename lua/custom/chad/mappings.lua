local M = {}

M.disabled = {
  t = {
    ["<C-x>"] = ""
  }
}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {"<cmd> DapToggleBreakpoint <CR>"}
  }
}

M.dap_python = {
  plugin = true,
  n = {
    ["<leader>dpr"] = {
      function()
        require('dap').continue()
      end
    }
  }
}

M.general = {
  n = {
    ["<C-Left>"] = { "<C-w>h", "Window left" },
    ["<C-Right>"] = { "<C-w>l", "Window right" },
    ["<C-Down>"] = { "<C-w>j", "Window down" },
    ["<C-Up>"] = { "<C-w>k", "Window up" },
    ["<leader>ac"] = { ":lua ansible_vault_encrypt() <CR>", "Encrypt File with Ansible-Vault" },
    ["<leader>at"] = { ":lua terminal_cwd() <CR>", "Open terminal in current files Working-Directory" },
    ["<leader>X"] = { ":lua close_all_buffers() <CR>", "Close all buffer except the current one" },
    ["<leader>fc"] = { ":FzfLua command_history <CR>", "Find command history" },
  },
  v = {
    ["/"] = { ":lua search_selected_text() <CR>", "Search for selection in current file"},
  }
}

M.nvimtree = {
  plugin = true,

  n = {
    -- toggle
    ["<C-m>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },

    -- focus
    ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "Focus nvimtree" },
  },
}


return M
