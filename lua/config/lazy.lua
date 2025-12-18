-- ============================================================================
-- LAZY.LUA - Bootstrap et configuration du plugin manager lazy.nvim
-- ============================================================================
-- Description: Installation et configuration automatique de lazy.nvim
-- Basé sur: LazyVim, lazy.nvim documentation
-- ============================================================================

-- ============================================================================
-- BOOTSTRAP LAZY.NVIM
-- ============================================================================
-- Installation automatique de lazy.nvim s'il n'est pas présent

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  -- Clone lazy.nvim depuis GitHub
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Utilise la dernière version stable
    lazypath,
  })
end

-- Ajoute lazy.nvim au runtimepath
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- CONFIGURATION LAZY.NVIM
-- ============================================================================

require("lazy").setup({
  -- ============================================================================
  -- IMPORT DES SPECS DE PLUGINS
  -- ============================================================================
  -- Lazy.nvim va automatiquement charger tous les fichiers dans lua/plugins/
  { import = "plugins" },

}, {
  -- ============================================================================
  -- OPTIONS DE LAZY.NVIM
  -- ============================================================================

  -- Répertoire d'installation des plugins
  root = vim.fn.stdpath("data") .. "/lazy",

  -- Configuration par défaut pour tous les plugins
  defaults = {
    lazy = false,     -- Par défaut, les plugins ne sont pas lazy-loaded
    version = nil,    -- Pas de version par défaut, utilise la branche main
  },

  -- Installation automatique des plugins manquants au démarrage
  install = {
    missing = true,
    colorscheme = { "tokyonight", "habamax" }, -- Colorschemes de secours
  },

  -- Configuration du checker pour les mises à jour
  checker = {
    enabled = true,       -- Vérifie automatiquement les mises à jour
    notify = false,       -- Ne notifie pas à chaque vérification (évite le spam)
    frequency = 3600,     -- Vérifie toutes les heures (3600 secondes)
    check_pinned = false, -- N'ignore pas les plugins épinglés
  },

  -- Notifications de changement
  change_detection = {
    enabled = true,       -- Détecte les changements de config
    notify = false,       -- Ne notifie pas (évite le spam lors du développement)
  },

  -- Interface utilisateur
  ui = {
    size = { width = 0.8, height = 0.8 },   -- Taille de la fenêtre (80% de l'écran)
    wrap = true,                             -- Wrap le texte long
    border = "rounded",                      -- Bordure arrondie
    title = "📦 Lazy Plugin Manager",       -- Titre de la fenêtre
    title_pos = "center",                    -- Position du titre

    -- Icônes (nécessite une Nerd Font)
    icons = {
      cmd = "",
      config = "",
      event = "⚡",
      ft = "",
      init = "",
      import = "󰋺",
      keys = "",
      lazy = "󰒲",
      loaded = "",
      not_loaded = "",
      plugin = "",
      runtime = "",
      require = "",
      source = "",
      start = "",
      task = "",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },

    -- Raccourcis dans l'UI de Lazy
    custom_keys = {
      -- Ouvrir le terminal pour l'action du plugin
      ["<localleader>t"] = {
        function(plugin)
          require("lazy.util").float_term(nil, {
            cwd = plugin.dir,
          })
        end,
        desc = "Open terminal in plugin dir",
      },
    },
  },

--   -- Readme
--   readme = {
--     enabled = true,
--     root = vim.fn.stdpath("state") .. "/lazy/readme",
--     files = { "README.md", "lua/**/README.md" },
--     skip_if_doc_exists = true,
--   },

  -- Performance
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,  -- Reset le packpath pour améliorer les performances
    rtp = {
      reset = true,         -- Reset le runtimepath pour améliorer les performances

      -- Désactive certains plugins built-in de Neovim rarement utilisés
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },

  -- Profiling
  profiling = {
    loader = false,
    require = false,
  },

  -- Configuration Git
  git = {
    log = { "-8" },           -- Affiche les 8 derniers commits
    timeout = 120,            -- Timeout pour les opérations git (secondes)
    url_format = "https://github.com/%s.git",
    filter = true,            -- Utilise --filter=blob:none pour les clones
  },

  -- Lockfile
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",

  -- Development (utile si vous développez des plugins)
  dev = {
    path = "~/projects",      -- Chemin vers vos plugins locaux
    patterns = {},            -- Patterns pour détecter les plugins locaux
    fallback = false,         -- Fallback vers GitHub si plugin local pas trouvé
  },

  -- Debug
  debug = false,              -- Active le mode debug (verbose logs)
})

-- ============================================================================
-- KEYMAPS POUR LAZY
-- ============================================================================
-- Ces keymaps sont aussi définis dans keymaps.lua mais on les répète ici
-- pour une installation fraîche

vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy Plugin Manager" })
vim.keymap.set("n", "<leader>L", "<cmd>Lazy update<cr>", { desc = "Lazy Update Plugins" })

-- ============================================================================
-- AUTO-COMMANDES
-- ============================================================================

-- Ouvre automatiquement Lazy au premier démarrage si des plugins sont manquants
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local lazy_stats = require("lazy").stats()
    if lazy_stats.count == 0 then
      vim.notify("No plugins installed. Opening Lazy...", vim.log.levels.INFO)
      vim.cmd("Lazy")
    end
  end,
})

-- Notification de succès après sync/installation
vim.api.nvim_create_autocmd("User", {
  pattern = "LazySync",
  callback = function()
    vim.notify("✅ Plugins synchronized successfully!", vim.log.levels.INFO)
  end,
})

-- ============================================================================
-- NOTES
-- ============================================================================
-- Installation :
--   1. Ce fichier s'occupe automatiquement de l'installation de lazy.nvim
--   2. Les plugins sont définis dans lua/plugins/*.lua
--   3. Lazy charge automatiquement tous les fichiers dans lua/plugins/
--
-- Commandes utiles :
--   :Lazy             - Ouvrir l'interface de Lazy
--   :Lazy sync        - Installer/Mettre à jour/Nettoyer les plugins
--   :Lazy update      - Mettre à jour tous les plugins
--   :Lazy clean       - Supprimer les plugins non utilisés
--   :Lazy check       - Vérifier les mises à jour disponibles
--   :Lazy profile     - Profiler les temps de chargement
--   :Lazy restore     - Restaurer depuis lazy-lock.json
--
-- Structure recommandée dans lua/plugins/ :
--   colorscheme.lua   - Thèmes de couleurs
--   editor.lua        - Plugins d'édition (autopairs, comments, etc.)
--   ui.lua            - Interface (statusline, bufferline, indent, etc.)
--   lsp.lua           - LSP, autocompletion, snippets
--   treesitter.lua    - Treesitter et modules
--   tools.lua         - Outils (telescope, neo-tree, etc.)
-- ============================================================================
