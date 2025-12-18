-- ============================================================================
-- TELESCOPE.LUA - Fuzzy finder et recherche
-- ============================================================================
-- Description: Configuration de Telescope pour find_files, live_grep, etc.
-- Utilisé par: Dashboard BIZZON, keymaps globaux
-- ============================================================================

return {
  -- ============================================================================
  -- TELESCOPE - Fuzzy Finder
  -- ============================================================================
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope", -- Lazy-load sur commande
    version = false,   -- Utilise la dernière version
    dependencies = {
      "nvim-lua/plenary.nvim",                            -- Requis (fonctions utilitaires)
      "nvim-tree/nvim-web-devicons",                      -- Icônes (Nerd Font)
      {
        "nvim-telescope/telescope-fzf-native.nvim",       -- Performance (algorithme en C)
        build = "make",
      },
    },

    -- ============================================================================
    -- KEYMAPS (lazy loading au premier appui)
    -- ============================================================================
    keys = {
      -- Find files
      { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },

      -- Find buffers
      { "<leader>,", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },

      -- Search string (grep)
      { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Search string" },

      -- Search keymaps
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Search keymaps" },

      -- Search help
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Search help" },

      -- Recent files (oldfiles)
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },

      -- Find in config
      {
        "<leader>fc",
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find config files"
      },

      -- Projects (nécessite project.nvim)
      { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "📂 Projects" },
    },

    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      -- ============================================================================
      -- CONFIGURATION TELESCOPE
      -- ============================================================================
      telescope.setup({
        defaults = {
          -- ============================================================================
          -- APPARENCE (Dracula theme)
          -- ============================================================================
          prompt_prefix = "🔍 ",   -- Icône de recherche
          selection_caret = "➜ ", -- Icône de sélection
          entry_prefix = "  ",     -- Indentation des résultats

          -- Bordures arrondies (style moderne)
          borderchars = {
            "─", "│", "─", "│",
            "╭", "╮", "╯", "╰",
          },

          -- Layout (2 colonnes : gauche recherche, droite preview)
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",      -- Prompt en haut à gauche
              preview_width = 0.55,         -- Preview prend 55% de la largeur
              width = 0.87,                 -- 87% de la largeur totale
              height = 0.87,                -- 87% de la hauteur totale
            },
            vertical = {
              -- En mode responsive (petit écran), passe en vertical
              prompt_position = "bottom",
              preview_height = 0.6,
              mirror = false,
            },
            width = 0.87,
            height = 0.87,
            preview_cutoff = 80,            -- Si largeur < 80 colonnes → mode vertical
          },

          -- Tri et recherche
          sorting_strategy = "ascending",  -- Résultats du haut vers le bas
          file_ignore_patterns = {
            -- ============================================================================
            -- FICHIERS À IGNORER (42 + Dev Web)
            -- ============================================================================

            -- Compilation C/C++ (42)
            "%.o$",
            "%.a$",
            "%.so$",
            "%.dylib$",
            "%.out$",
            "%.exe$",
            "%.obj$",
            "a%.out$",

            -- Python
            "%.pyc$",
            "%.pyo$",
            "__pycache__/",
            "%.egg%-info/",
            "%.egg$",
            "venv/",
            "%.venv/",
            "env/",

            -- JavaScript/TypeScript (Dev Web)
            "node_modules/",
            "%.min%.js$",
            "%.min%.css$",
            "dist/",
            "build/",
            "%.next/",
            "%.nuxt/",
            "%.output/",
            "coverage/",
            "%.npm/",
            "yarn%.lock",
            "package%-lock%.json",

            -- Contrôle de version
            "%.git/",
            "%.svn/",
            "%.hg/",

            -- IDE et éditeurs
            "%.vscode/",
            "%.idea/",
            "%.DS_Store$",
            "%.sublime%-workspace$",
            "%.sublime%-project$",

            -- Fichiers temporaires
            "%.swp$",
            "%.swo$",
            "%.tmp$",
            "%~$",
            "%.bak$",
            "%.cache/",

            -- Système
            "Thumbs%.db$",
            "desktop%.ini$",

            -- Archives
            "%.zip$",
            "%.tar%.gz$",
            "%.rar$",
            "%.7z$",

            -- Images/Médias (optionnel, décommenter si tu veux les ignorer)
            -- "%.png$",
            -- "%.jpg$",
            -- "%.jpeg$",
            -- "%.gif$",
            -- "%.mp4$",
            -- "%.mp3$",
          },

          -- Preview
          preview = {
            treesitter = true,            -- Coloration syntaxique avec treesitter
          },

          -- Performance
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,

          -- ============================================================================
          -- KEYMAPS INTERNES TELESCOPE (quand Telescope est ouvert)
          -- ============================================================================
          -- ATTENTION : Éviter les conflits avec keymaps.lua
          mappings = {
            -- ========================================================================
            -- MODE INSERT (quand tu tapes dans Telescope)
            -- ========================================================================
            i = {
              -- Navigation dans les résultats (standard LazyVim/AstroVim/NvChad)
              -- ⚠️ <C-j/k> sont utilisés dans keymaps.lua pour navigation fenêtres
              -- MAIS en mode INSERT dans Telescope, pas de conflit car contexte différent
              ["<C-j>"] = actions.move_selection_next,     -- Résultat suivant ⬇️
              ["<C-k>"] = actions.move_selection_previous, -- Résultat précédent ⬆️
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,

              -- Historique de recherche
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,

              -- Scroll dans le preview
              -- ⚠️ <C-u/d> sont utilisés dans keymaps.lua pour scroll demi-page
              -- MAIS ici on est dans Telescope, donc pas de conflit
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,

              -- Ouvrir fichier
              ["<CR>"] = actions.select_default,           -- Ouvrir dans buffer actuel
              ["<C-x>"] = actions.select_horizontal,       -- Ouvrir en split horizontal
              ["<C-v>"] = actions.select_vertical,         -- Ouvrir en split vertical
              ["<C-t>"] = actions.select_tab,              -- Ouvrir en nouvel onglet

              -- Quickfix list
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,         -- Tous les résultats
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- Sélection

              -- Fermer Telescope
              ["<Esc>"] = actions.close,
              ["<C-c>"] = actions.close,

              -- Sélection multiple
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,

              -- Autres actions utiles
              ["<C-/>"] = actions.which_key, -- Afficher l'aide des keymaps (marche aussi avec <C-_>)
            },

            -- ========================================================================
            -- MODE NORMAL (si tu appuies sur Esc dans Telescope puis navigues)
            -- ========================================================================
            n = {
              -- Navigation
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,

              -- Scroll preview
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,

              -- Ouvrir fichier
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,

              -- Quickfix
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

              -- Fermer
              ["q"] = actions.close,
              ["<Esc>"] = actions.close,

              -- Sélection multiple
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,

              -- Aide
              ["?"] = actions.which_key,
            },
          },

          -- ============================================================================
          -- COULEURS (Dracula theme)
          -- ============================================================================
          -- Les highlights sont définis après le setup (voir plus bas)
        },

        -- ============================================================================
        -- PICKERS SPÉCIFIQUES (configurations par picker)
        -- ============================================================================
        pickers = {
          -- Find files
          find_files = {
            -- Layout automatique : vertical par défaut
            -- En responsive (petit écran), adapte automatiquement
            previewer = true,
            hidden = false,           -- N'affiche pas les fichiers cachés par défaut
            -- Pour inclure les fichiers cachés : <leader>fF (à définir dans keymaps.lua)
          },

          -- Recent files
          oldfiles = {
            previewer = true,
            only_cwd = false,  -- Affiche tous les fichiers récents, pas que ceux du CWD
          },

          -- Live grep
          live_grep = {
            previewer = true,
          },

          -- Buffers
          buffers = {
            previewer = true,
            initial_mode = "normal",  -- Démarre en mode normal (pas insert)
            sort_mru = true,          -- Trie par Most Recently Used
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer, -- Supprimer buffer avec C-d
              },
              n = {
                ["dd"] = actions.delete_buffer,    -- Supprimer buffer avec dd
              },
            },
          },

          -- Help tags
          help_tags = {
            previewer = true,
          },

          -- Keymaps
          keymaps = {
            previewer = false,        -- Pas de preview pour les keymaps
          },

          -- Projects (intégration project.nvim)
          projects = {
            previewer = false,        -- Pas de preview pour la liste des projets
          },
        },

        -- ============================================================================
        -- EXTENSIONS
        -- ============================================================================
        extensions = {
          -- FZF Native (performance)
          fzf = {
            fuzzy = true,                   -- Recherche floue
            override_generic_sorter = true, -- Remplace le sorter par défaut
            override_file_sorter = true,    -- Remplace le file sorter
            case_mode = "smart_case",       -- smart case (comme dans options.lua)
          },
        },
      })

      -- ============================================================================
      -- CHARGER LES EXTENSIONS
      -- ============================================================================
      telescope.load_extension("fzf")

      -- ============================================================================
      -- HIGHLIGHTS DRACULA (couleurs personnalisées)
      -- ============================================================================
      local colors = {
        bg = "#282A36",
        fg = "#F8F8F2",
        selection = "#44475A",
        comment = "#6272A4",
        red = "#FF5555",
        orange = "#FFB86C",
        yellow = "#F1FA8C",
        green = "#50FA7B",
        purple = "#BD93F9",
        cyan = "#8BE9FD",
        pink = "#FF79C6",
      }

      -- Appliquer les couleurs
      vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = colors.purple, bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = colors.purple, bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = colors.purple, bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = colors.purple, bg = "NONE" })

      vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = colors.bg, bg = colors.purple, bold = true })
      vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = colors.bg, bg = colors.cyan, bold = true })
      vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = colors.bg, bg = colors.green, bold = true })

      vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = colors.fg, bg = colors.selection, bold = true })
      vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = colors.pink, bg = colors.selection })
      vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = colors.purple })
      vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = colors.yellow, bold = true })

      -- Background opaque (cache l'arrière-plan du dashboard)
      vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = colors.bg })
      vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = colors.bg })
      vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = colors.bg })
      vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = colors.bg })
    end,
  },
}

-- ============================================================================
-- NOTES
-- ============================================================================
-- Commandes Telescope disponibles (via keymaps.lua) :
--   <leader>ff  - Find files
--   <leader>fr  - Recent files
--   <leader>fb  - Buffers
--   <leader>ss  - Live grep (search text)
--   <leader>sk  - Keymaps
--   <leader>sh  - Help tags
--   <leader>fc  - Find in config
--
-- Keymaps dans Telescope (quand ouvert) :
--   <C-n/p>     - Naviguer résultats (mode insert)
--   <C-j/k>     - Historique recherche (mode insert)
--   j/k         - Naviguer résultats (mode normal)
--   <C-x>       - Ouvrir en split horizontal
--   <C-v>       - Ouvrir en split vertical
--   <C-t>       - Ouvrir en onglet
--   <C-q>       - Envoyer vers quickfix
--   <Tab>       - Sélection multiple
--   <C-u/d>     - Scroll preview
--   <Esc>       - Fermer
--   ?           - Aide (mode normal)
--   <C-/>       - Aide (mode insert)
--
-- Extensions chargées :
--   - telescope-fzf-native (performance, tri optimisé)
--
-- À venir :
--   - telescope-project (pour <leader>fp) → Dans project.lua
--
-- Performance :
--   - Lazy-load sur commande (pas au démarrage)
--   - FZF native (algorithme C)
--   - file_ignore_patterns optimisé pour 42 + dev web
-- ============================================================================
