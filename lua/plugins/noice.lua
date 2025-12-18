-- ============================================================================
-- NOICE.LUA - Cmdline popup minimale
-- ============================================================================
-- Description: Interface moderne pour la cmdline uniquement (popup centré)
-- Plugin: folke/noice.nvim
-- Style: Cmdline en popup au centre, sans notifications ni messages
-- ============================================================================

return {
  -- ============================================================================
  -- NOICE - Configuration minimale (cmdline uniquement)
  -- ============================================================================
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim", -- Bibliothèque UI (required)
    },
    enabled = true,
    opts = {
      -- ==========================================================================
      -- LSP - Désactivé complètement
      -- ==========================================================================
      lsp = {
        override = {},
        hover = { enabled = false },
        signature = { enabled = false },
        progress = { enabled = false },
        message = { enabled = false },
      },

      -- ==========================================================================
      -- PRESETS - Configuration minimale (comme LazyVim)
      -- ==========================================================================
      presets = {
        bottom_search = true,         -- Recherche en bas (style Vim classique)
        command_palette = true,       -- Cmdline en popup stylé au centre
        long_message_to_split = false,
        inc_rename = false,
        lsp_doc_border = false,
      },

      -- ==========================================================================
      -- CMDLINE - Configuration de la ligne de commande
      -- ==========================================================================
      cmdline = {
        enabled = true,         -- Active la cmdline popup
        view = "cmdline_popup", -- Style: popup au centre

        -- Format selon le type de commande
        format = {
          -- Commandes normales (:)
          cmdline = {
            pattern = "^:",
            icon = "",
            lang = "vim",
            title = " Cmdline ",
            -- 🎨 TREESITTER : Coloration syntaxique en temps réel
            opts = { buf_options = { filetype = "vim" } },
          },

          -- Filter (:!)
          filter = {
            pattern = "^:%s*!",
            icon = "$",
            lang = "bash",
            title = "",
            -- 🎨 TREESITTER : Coloration des commandes shell
            opts = { buf_options = { filetype = "bash" } },
          },

          -- Lua (:lua)
          lua = {
            pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
            icon = "",
            lang = "lua",
            title = "",
            -- 🎨 TREESITTER : Coloration syntaxique Lua
            opts = { buf_options = { filetype = "lua" } },
          },

          -- Help (:help)
          help = {
            pattern = "^:%s*he?l?p?%s+",
            icon = "󰋖",
            title = "",
          },

          -- Input (vim.ui.input)
          input = {
            view = "cmdline_input",
            icon = "󰥻 ",
          },
        },
      },

      -- ==========================================================================
      -- MESSAGES - Désactivé (utilise les messages Neovim par défaut)
      -- ==========================================================================
      messages = {
        enabled = false,
      },

      -- ==========================================================================
      -- POPUPMENU - Menu d'autocomplétion cmdline
      -- ==========================================================================
      popupmenu = {
        enabled = true,   -- Active le popup pour autocomplétion
        backend = "nui",  -- Backend: "nui" ou "cmp"
      },

      -- ==========================================================================
      -- NOTIFICATIONS - Désactivé
      -- ==========================================================================
      notify = {
        enabled = false,
      },

      -- ==========================================================================
      -- ROUTES - Routage des messages (minimal)
      -- ==========================================================================
      routes = {},

      -- ==========================================================================
      -- VIEWS - Configuration des vues
      -- ==========================================================================
      views = {
        -- Cmdline popup (commandes :)
        cmdline_popup = {
          position = {
            row = "30%", -- Centré verticalement
            col = "50%", -- Centré horizontalement
          },
          size = {
            width = 60, -- Largeur du popup
            height = "auto",
          },
          border = {
            style = "rounded",      -- Bordures arrondies
            padding = { 0, 0.5 },   -- Padding interne
          },
          win_options = {
            winhighlight = {
              Normal = "Normal",
              FloatBorder = "DiagnosticInfo",
            },
          },
        },
      },
    },
  },
}
