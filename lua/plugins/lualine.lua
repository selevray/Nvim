-- ============================================================================
-- LUALINE.LUA - Statusline LazyVim-style
-- ============================================================================
-- Description: Barre de statut configurée exactement comme LazyVim
-- Plugin: nvim-lualine/lualine.nvim
-- Style: Auto theme, layout LazyVim, fonctionnel et minimaliste
-- ============================================================================

return {
  -- ============================================================================
  -- LUALINE - Statusline LazyVim-style
  -- ============================================================================
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy", -- Charge après le rendu initial (performance)
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- Icônes Nerd Font
    },

    opts = function()
      -- ==========================================================================
      -- HELPER FUNCTIONS (version simplifiée des fonctions LazyVim)
      -- ==========================================================================

      -- Fonction pour obtenir le nom du root directory
      local function get_root_dir()
        -- Détecte le root en cherchant .git, Makefile, etc.
        local markers = { ".git", "Makefile", "package.json", "Cargo.toml", "go.mod" }
        local cwd = vim.fn.getcwd()

        for _, marker in ipairs(markers) do
          local root = vim.fn.finddir(marker, cwd .. ";")
          if root ~= "" then
            local root_path = vim.fn.fnamemodify(root, ":h")
            return "󱉭 " .. vim.fn.fnamemodify(root_path, ":t")
          end

          local file = vim.fn.findfile(marker, cwd .. ";")
          if file ~= "" then
            local root_path = vim.fn.fnamemodify(file, ":h")
            return "󱉭 " .. vim.fn.fnamemodify(root_path, ":t")
          end
        end

        -- Si pas de marker trouvé, retourne le nom du cwd
        return "󱉭 " .. vim.fn.fnamemodify(cwd, ":t")
      end

      -- Fonction pour afficher joliment le chemin du fichier
      local function pretty_path()
        -- Si on est dans neo-tree, affiche juste l'icône
        if vim.bo.filetype == "neo-tree" then
          return ""
        end

        local path = vim.fn.expand("%:~:.")
        if path == "" then
          return ""
        end

        -- Si le fichier est modifié, ajoute un indicateur
        local modified = vim.bo.modified and " " or ""

        -- Si readonly, ajoute l'icône
        local readonly = vim.bo.readonly and " 󰌾 " or ""

        return path .. modified .. readonly
      end

      -- ==========================================================================
      -- CONFIGURATION LUALINE
      -- ==========================================================================
      return {
        -- ========================================================================
        -- OPTIONS GLOBALES
        -- ========================================================================
        options = {
          theme = "auto",  -- Détection automatique du thème (comme LazyVim)
          globalstatus = true,  -- Statusline globale (laststatus = 3)

          -- Désactive sur les dashboards
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
            winbar = {},
          },
        },

        -- ========================================================================
        -- SECTIONS - Layout LazyVim
        -- ========================================================================
        -- ┌──────────────────────────────────────────────────────────────────────┐
        -- │ MODE │  branch │ 󱉭 root  diagnostics  icon file  │  dap  diff  pos %│
        -- └──────────────────────────────────────────────────────────────────────┘
        --   └─a─┘  └───b──┘  └──────────────c────────────────┘  └────x───  ─y──┘
        -- ========================================================================

        sections = {
          -- ====================================================================
          -- SECTION A : Mode (NORMAL, INSERT, VISUAL, etc.)
          -- ====================================================================
          lualine_a = { "mode" },

          -- ====================================================================
          -- SECTION B : Git branch uniquement
          -- ====================================================================
          lualine_b = { "branch" },

          -- ====================================================================
          -- SECTION C : Root dir + Diagnostics + Filetype icon + Filename
          -- ====================================================================
          lualine_c = {
            -- Root directory avec icône
            {
              get_root_dir,
              color = { fg = "#BD93F9" }, -- Violet Dracula (Special)
            },

            -- Diagnostics LSP
            {
              "diagnostics",
              symbols = {
                error = " ",
                warn = " ",
                info = " ",
                hint = " ",
              },
            },

            -- Filetype - ICÔNE SEULEMENT (pas de texte)
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = { left = 1, right = 0 },
            },

            -- Nom du fichier avec pretty path
            {
              pretty_path,
              padding = { left = 0, right = 1 },
            },
          },

          -- ====================================================================
          -- SECTION X : DAP debugger + Git diff
          -- ====================================================================
          lualine_x = {
            -- DAP debugger status (uniquement si actif)
            {
              function()
                local ok, dap = pcall(require, "dap")
                if ok then
                  local status = dap.status()
                  if status ~= "" then
                    return "  " .. status
                  end
                end
                return ""
              end,
              cond = function()
                local ok, dap = pcall(require, "dap")
                return ok and dap.status() ~= ""
              end,
              color = { fg = "#50FA7B" }, -- Vert Dracula (Debug)
            },

            -- Git diff (déplacé ici depuis section B, comme LazyVim)
            {
              "diff",
              symbols = {
                added = " ",
                modified = " ",
                removed = " ",
              },
            },
          },

          -- ====================================================================
          -- SECTION Y : Progress + Location
          -- ====================================================================
          lualine_y = {
            {
              "progress",
              separator = " ",
              padding = { left = 1, right = 0 },
            },
            {
              "location",
              padding = { left = 0, right = 1 },
            },
          },

          -- ====================================================================
          -- SECTION Z : Vide (pas d'horloge, comme demandé)
          -- ====================================================================
          lualine_z = {},
        },

        -- ========================================================================
        -- SECTIONS INACTIVES (fenêtres non focusées)
        -- ========================================================================
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "lazy" },
      }
    end,
  },
}
