-- ============================================================================
-- TREESITTER.LUA - Configuration de nvim-treesitter
-- ============================================================================
-- Description: Analyse syntaxique avancée pour coloration, indentation,
--              sélection incrémentale, et navigation de code
-- ============================================================================

return {
  -- ============================================================================
  -- NVIM-TREESITTER - Parser de code et modules
  -- ============================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- Dernière version depuis main
    build = ":TSUpdate", -- Met à jour les parsers après installation
    event = { "BufReadPost", "BufNewFile", "BufWritePre" }, -- Lazy-load sur ouverture de fichier

    dependencies = {
      -- Module pour afficher le contexte (fonction/classe actuelle)
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          enable = true,
          max_lines = 3, -- Nombre maximum de lignes de contexte
          min_window_height = 20, -- Hauteur minimale de fenêtre pour activer
          line_numbers = true,
          multiline_threshold = 1,
          trim_scope = 'outer',
          mode = 'cursor',
          separator = '─', -- Caractère de séparation
          zindex = 20,
        },
      },

      -- Rainbow brackets - Parenthèses colorées
      {
        "HiPhish/rainbow-delimiters.nvim",
        config = function()
          local rainbow = require("rainbow-delimiters")
          require("rainbow-delimiters.setup").setup({
            strategy = {
              [''] = rainbow.strategy['global'],
              vim = rainbow.strategy['local'],
            },
            query = {
              [''] = 'rainbow-delimiters',
              lua = 'rainbow-blocks',
            },
            highlight = {
              'RainbowDelimiterRed',
              'RainbowDelimiterYellow',
              'RainbowDelimiterBlue',
              'RainbowDelimiterOrange',
              'RainbowDelimiterGreen',
              'RainbowDelimiterViolet',
              'RainbowDelimiterCyan',
            },
          })
        end,
      },

      -- Autotag - Fermeture automatique des balises HTML/JSX
      {
        "windwp/nvim-ts-autotag",
        opts = {
          autotag = {
            enable = true,
            enable_rename = true,
            enable_close = true,
            enable_close_on_slash = true,
            filetypes = {
              'html', 'javascript', 'typescript', 'javascriptreact',
              'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx',
              'astro', 'xml',
            },
          },
        },
      },
    },

    -- ============================================================================
    -- CONFIGURATION
    -- ============================================================================
    opts = {
      -- Liste des parsers à installer
      ensure_installed = {
        -- Vos langages principaux
        "c",
        "cpp",
        "javascript",
        "typescript",
        "astro",
        "html",
        "css",
        "lua",

        -- Formats courants
        "json",
        "jsonc",
        "yaml",
        "toml",

        -- Web supplémentaire
        "tsx",
        "jsx",
        "scss",

        -- Documentation
        "markdown",
        "markdown_inline",

        -- Configuration
        "vim",
        "vimdoc",
        "bash",

        -- Autres utiles
        "regex",
        "jsdoc",
        "comment",
      },

      -- Installation automatique des parsers manquants
      auto_install = true,

      -- Synchronisation de l'installation (bloque jusqu'à la fin)
      sync_install = false,

      -- ============================================================================
      -- MODULES TREESITTER
      -- ============================================================================

      -- Coloration syntaxique améliorée
      highlight = {
        enable = true,

        -- Désactive treesitter pour les très gros fichiers (performance)
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,

        -- Active la coloration Vim en plus (fallback)
        additional_vim_regex_highlighting = false,
      },

      -- Indentation basée sur Tree-sitter
      indent = {
        enable = true,
        -- Désactive pour certains langages si problématique
        disable = {},
      },

      -- Sélection incrémentale
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",    -- Ctrl+Space : Initialiser la sélection
          node_incremental = "<C-space>",  -- Ctrl+Space : Étendre la sélection
          scope_incremental = "<C-s>",     -- Ctrl+S : Sélectionner le scope parent
          node_decremental = "<C-backspace>", -- Ctrl+Backspace : Réduire la sélection
        },
      },

      -- Modules automatiques (autotag géré par dépendance)
      autotag = {
        enable = true,
      },
    },

    -- ============================================================================
    -- CONFIGURATION POST-INSTALLATION
    -- ============================================================================
    config = function(_, opts)
      -- Charge la configuration de nvim-treesitter
      require("nvim-treesitter").setup(opts)

      -- Active le folding basé sur Tree-sitter
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

      -- IMPORTANT : Par défaut, tout est déplié
      vim.opt.foldenable = false  -- Désactive le folding au démarrage
      vim.opt.foldlevel = 99      -- Niveau de fold très élevé = tout déplié
      vim.opt.foldlevelstart = 99 -- Commence avec tout déplié

      -- Options de folding
      vim.opt.foldnestmax = 10    -- Maximum 10 niveaux de folding
      vim.opt.foldminlines = 1    -- Minimum 1 ligne pour créer un fold

      -- Texte affiché pour les folds
      vim.opt.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]

      -- ============================================================================
      -- KEYMAPS POUR TREE-SITTER
      -- ============================================================================
      -- Raccourcis pour utiliser Tree-sitter

      vim.keymap.set("n", "<leader>th", "<cmd>TSHighlightCapturesUnderCursor<cr>",
        { desc = "Tree-sitter: Show Highlight Groups" })

      vim.keymap.set("n", "<leader>tp", "<cmd>TSPlaygroundToggle<cr>",
        { desc = "Tree-sitter: Toggle Playground" })

      vim.keymap.set("n", "<leader>ti", "<cmd>Inspect<cr>",
        { desc = "Tree-sitter: Inspect (Neovim 0.9+)" })

      -- Raccourcis pour le folding (za, zc, zo sont déjà des commandes Vim natives)
      -- On les redéfinit juste pour ajouter des descriptions
      vim.keymap.set("n", "za", "za", { desc = "Toggle fold under cursor" })
      vim.keymap.set("n", "zA", "zA", { desc = "Toggle all folds under cursor" })
      vim.keymap.set("n", "zc", "zc", { desc = "Close fold under cursor" })
      vim.keymap.set("n", "zC", "zC", { desc = "Close all folds under cursor" })
      vim.keymap.set("n", "zo", "zo", { desc = "Open fold under cursor" })
      vim.keymap.set("n", "zO", "zO", { desc = "Open all folds under cursor" })
      vim.keymap.set("n", "zm", "zm", { desc = "Fold more (close one level)" })
      vim.keymap.set("n", "zM", "zM", { desc = "Close all folds" })
      vim.keymap.set("n", "zr", "zr", { desc = "Fold less (open one level)" })
      vim.keymap.set("n", "zR", "zR", { desc = "Open all folds" })
    end,
  },
}
