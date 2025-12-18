-- ============================================================================
-- BUFFERLINE.LUA - Onglets de buffers en haut
-- ============================================================================
-- Description: Tabline moderne avec onglets pour les buffers ouverts
-- Plugin: akinsho/bufferline.nvim

-- ============================================================================

-- ============================================================================
-- FONCTION DE SUPPRESSION AVEC CONFIRMATION
-- ============================================================================
local function delete_buffer(bufnr)
  local bd = require("mini.bufremove").delete
  bufnr = bufnr or 0

  if vim.api.nvim_buf_get_option(bufnr, 'modified') then
    local bufname = bufnr == 0 and vim.fn.bufname() or vim.api.nvim_buf_get_name(bufnr)
    local choice = vim.fn.confirm(("Save changes to %q?"):format(bufname), "&Yes\n&No\n&Cancel")
    if choice == 1 then -- Yes
      if bufnr == 0 then
        vim.cmd.write()
      else
        vim.api.nvim_buf_call(bufnr, function() vim.cmd.write() end)
      end
      bd(bufnr)
    elseif choice == 2 then -- No
      bd(bufnr, true)
    end
    -- choice == 3 (Cancel) : ne fait rien
  else
    bd(bufnr)
  end
end

return {
  -- ============================================================================
  -- BUFFERLINE - Onglets de buffers
  -- ============================================================================
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "BufReadPost", -- Charge uniquement quand on ouvre un fichier (pas sur dashboard)
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- Icônes pour les filetypes
    },

    -- Keymaps pour navigation entre buffers
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },

    opts = {
      options = {
        -- ====================================================================
        -- STYLE ET APPARENCE
        -- ====================================================================
        mode = "buffers",                    -- "buffers" ou "tabs"
        themable = true,                     -- Permet au thème de customiser

        -- Séparateurs (style LazyVim)
        separator_style = "thin",            -- "slant", "slope", "thick", "thin", { 'any', 'any' }
        indicator = {
          icon = "▎",                        -- Indicateur du buffer actif
          style = "icon",                    -- "icon", "underline", "none"
        },

        -- Icônes
        buffer_close_icon = "󰅖",
        -- modified_icon = "●",
        close_icon = "󰅖",
        left_trunc_marker = "",
        right_trunc_marker = "",

        -- Utilise un format custom pour afficher à la fois modified ET close icon
        -- name_formatter = function(buf)
        --   -- Ajoute l'icône de modification au nom si le buffer est modifié
        --   if vim.bo[buf.bufnr].modified then
        --     return buf.name .. " ●"
        --   end
        --   return buf.name
        -- end,

        -- ====================================================================
        -- FONCTIONNALITÉS
        -- ====================================================================
        -- Utilise la fonction de suppression avec confirmation personnalisée
        close_command = delete_buffer,
        right_mouse_command = function(n)
          -- Utilise vim.defer_fn pour éviter que noice intercepte l'événement souris
          vim.defer_fn(function()
            delete_buffer(n)
          end, 0)
        end,

        diagnostics = "nvim_lsp",            -- Affiche les diagnostics LSP
        diagnostics_update_in_insert = false,

        -- Icônes de diagnostics
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,

        -- Nombre de buffers visibles
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 18,
        truncate_names = true,

        -- ====================================================================
        -- OFFSETS (espaces réservés)
        -- ====================================================================
        offsets = {
          {
            filetype = "neo-tree",
            -- text = "󰙅 File Explorer",
            -- text_align = "center",
            separator = true,
          },
        },

        -- ====================================================================
        -- COMPORTEMENT
        -- ====================================================================
        show_buffer_icons = true,            -- Icônes de filetype
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = true,



        persist_buffer_sort = true,          -- Garde l'ordre des buffers
        move_wraps_at_ends = false,

        -- Groupes (ex: tous les fichiers .lua ensemble)
        groups = {
          options = {
            toggle_hidden_on_enter = true,
          },
          items = {
            {
              name = "Tests",
              highlight = { underline = true, sp = "blue" },
              priority = 2,
              icon = "",
              matcher = function(buf)
                return buf.name:match("_spec") or buf.name:match("_test")
              end,
            },
            {
              name = "Docs",
              highlight = { underline = true, sp = "green" },
              auto_close = false,
              matcher = function(buf)
                return buf.name:match("%.md") or buf.name:match("%.txt")
              end,
            },
          },
        },

        -- ====================================================================
        -- TRI (ordre des buffers)
        -- ====================================================================
        sort_by = "insert_after_current",    -- "insert_after_current", "insert_at_end", "id", "extension", "relative_directory", "directory", "tabs"

        -- ====================================================================
        -- HOVER (survol avec la souris)
        -- ====================================================================
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
      },

      -- ==========================================================================
      -- HIGHLIGHTS - Customisation des couleurs (optionnel avec thème auto)
      -- ==========================================================================
      highlights = {
        -- LazyVim utilise le thème auto, pas besoin de customiser
        -- Mais si tu veux forcer des couleurs Dracula :
        -- fill = { bg = "#282A36" },
        -- background = { fg = "#6272A4" },
        -- buffer_selected = { fg = "#F8F8F2", bold = true, italic = false },
      },
    },

    config = function(_, opts)
      require("bufferline").setup(opts)

      -- Fix bufferline quand on restaure une session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },

  -- ============================================================================
  -- MINI.BUFREMOVE - Suppression propre des buffers
  -- ============================================================================
  -- Note: Utilisé par bufferline pour fermer les buffers proprement
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>bd",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>bD",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "Delete Buffer (Force)",
      },
    },
  },
}
