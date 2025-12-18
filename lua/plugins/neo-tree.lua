-- ============================================================================
-- NEO-TREE.LUA - File Explorer
-- ============================================================================
-- Description: Explorateur de fichiers moderne pour Neovim
-- Plugin: nvim-neo-tree/neo-tree.nvim
-- ============================================================================

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e",  "<cmd>Neotree toggle<cr>",     desc = "Toggle Neo-tree (Files)" },
    { "<leader>o",  "<cmd>Neotree focus<cr>",      desc = "Focus Neo-tree" },
    { "<leader>be", "<cmd>Neotree buffers<cr>",    desc = "Neo-tree Buffers" },
    { "<leader>ge", "<cmd>Neotree git_status<cr>", desc = "Neo-tree Git Status" },
  },
  opts = {
    sources = { "filesystem", "buffers", "git_status" },
    enable_git_status = true,
    enable_diagnostics = true,
    auto_clean_after_session_restore = true,
    close_if_last_window = false,
    popup_border_style = "rounded",

    source_selector = {
        winbar = true, -- Affiche les onglets dans la winbar
        statusline = false,
        show_scrolled_off_parent_node = false,
        sources = {
            { source = "filesystem", display_name = " 󰉋 Files " },
            { source = "buffers", display_name = " 󰈙 Bufs " },
            { source = "git_status", display_name = " 󰊢 Git " },
        },
        content_layout = "start", -- "start", "center", "end"
        tabs_layout = "equal", -- "equal", "active"
        truncation_character = "…",
        tabs_min_width = nil,
        tabs_max_width = nil,
        padding = 0,
        separator = { left = "▏", right = "▕" },
        separator_active = nil,
        show_separator_on_edge = false,
        highlight_tab = "NeoTreeTabInactive",
        highlight_tab_active = "NeoTreeTabActive",
        highlight_background = "NeoTreeTabInactive",
        highlight_separator = "NeoTreeTabSeparatorInactive",
        highlight_separator_active = "NeoTreeTabSeparatorActive",
    },

    default_component_configs = {
        indent = {
            indent_size = 2,
            padding = 1,
        },

        -- Icônes Git
        git_status = {
            symbols = {
              added     = "", -- nf-fa-plus
              modified  = "", -- nf-fa-pencil
              deleted   = "", -- nf-fa-times
              renamed   = "󰁕", -- nf-md-file_move
              untracked = "", -- nf-fa-question
              ignored   = "", -- nf-fa-eye_slash
              unstaged  = "󰄱", -- nf-md-circle_outline
              staged    = "󰄵", -- nf-md-check_circle
              conflict  = "", -- nf-fa-exclamation_triangle
            }

        },
    },

    window = {
        position = "left",
        width = 35,              -- Augmenté pour afficher les onglets confortablement
        mappings = {
            ["<space>"] = "none", -- Désactive space pour éviter conflit avec leader
            ["<Tab>"] = "next_source", -- Tab pour onglet suivant
            ["<S-Tab>"] = "prev_source", -- Shift+Tab pour onglet précédent
            ["s"] = "none", -- Désactive 's' pour éviter conflit avec Flash
            ["<C-x>"] = "open_split", -- Ctrl+x pour split horizontal (LazyVim style)
            ["<C-v>"] = "open_vsplit", -- Ctrl+v pour split vertical (LazyVim style)
        },
    },

    filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = { ".git" },
        show_hidden_count = false,
      },
      hijack_netrw_behavior = "open_default",
      use_libuv_file_watcher = vim.fn.has "win32" ~= 1,
      components = {
          name = function(config, node, state)
              local result = require("neo-tree.sources.common.components").name(config, node, state)
              if node.type == "directory" and node:get_depth() == 1 then
                  result.text = vim.fn.fnamemodify(node.path, ":t")
              end
              return result
          end,
      },
    },

    buffers = {
      follow_current_file = { enabled = true },
      group_empty_dirs = true,
      show_unloaded = true,
      window = {
        mappings = {
          ["bd"] = "buffer_delete",
        },
      },
      components = {
          name = function(config, node, state)
              local result = require("neo-tree.sources.common.components").name(config, node, state)
              if node.type == "directory" and node:get_depth() == 1 then
                  result.text = vim.fn.fnamemodify(node.path, ":t")
              end
              return result
          end,
      },
    },

    git_status = {
      window = {
        position = "float",
        mappings = {
          -- Git Actions (inspiré de fugitive et lazygit)
          ["a"]  = "git_add_file",       -- add (stage un fichier)
          ["A"]  = "git_add_all",        -- add all (stage tout)
          ["u"]  = "git_unstage_file",   -- unstage
          ["r"]  = "git_revert_file",    -- revert/restore
          ["c"]  = "git_commit",         -- commit
          ["p"]  = "git_push",           -- push
          ["P"]  = "git_commit_and_push", -- Push (commit + push direct)
        },
      },
      components = {
          name = function(config, node, state)
              local result = require("neo-tree.sources.common.components").name(config, node, state)
              if node.type == "directory" and node:get_depth() == 1 then
                  result.text = vim.fn.fnamemodify(node.path, ":t")
              end
              return result
          end,
      },
    },

    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function(_)
          vim.opt_local.signcolumn = "auto"
          vim.opt_local.foldcolumn = "0"
        end,
      },
    },
  },

  config = function(_, opts)
    require("neo-tree").setup(opts)

    -- Couleurs Dracula pour les onglets neo-tree
    vim.api.nvim_set_hl(0, "NeoTreeTabInactive", {
      bg = "#282A36",
      fg = "#6272A4",
    })

    vim.api.nvim_set_hl(0, "NeoTreeTabActive", {
      bg = "#44475A",
      fg = "#F8F8F2",
      bold = true,
    })

    vim.api.nvim_set_hl(0, "NeoTreeTabSeparatorInactive", {
      fg = "#44475A",
      bg = "#282A36",
    })

    vim.api.nvim_set_hl(0, "NeoTreeTabSeparatorActive", {
      fg = "#BD93F9",
      bg = "#44475A",
    })

    -- Couleur pour les indent markers
    vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", {
      fg = "#44475A", -- Gris subtil du thème Dracula
    })
  end,
}
