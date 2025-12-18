return {
  -- ============================================================================
  -- PROJECT.NVIM - Project Management
  -- ============================================================================
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy", -- Lazy-load après le démarrage
    dependencies = {
      "nvim-telescope/telescope.nvim", -- Pour afficher la liste des projets
    },

    config = function()
      local project = require("project_nvim")

      -- ============================================================================
      -- CONFIGURATION
      -- ============================================================================
      project.setup({
        -- ========================================================================
        -- MÉTHODE DE DÉTECTION
        -- ========================================================================
        -- "pattern" : Détecte via fichiers/dossiers racine (plus fiable pour 42)
        -- "lsp"     : Détecte via Language Server (peut être imprécis)
        detection_methods = { "pattern" },

        -- ========================================================================
        -- PATTERNS DE DÉTECTION (ordre = priorité)
        -- ========================================================================
        -- Le plugin remonte l'arborescence jusqu'à trouver un de ces patterns
        patterns = {
          ".git",             -- Git repository (le plus courant)
          "_darcs",           -- Darcs VCS
          ".hg",              -- Mercurial
          ".bzr",             -- Bazaar
          ".svn",             -- Subversion
          "Makefile",         -- C/C++ projects
          "package.json",     -- Node.js / JavaScript
          "Cargo.toml",       -- Rust
          "go.mod",           -- Go
          "requirements.txt", -- Python (pip)
          "pyproject.toml",   -- Python moderne (poetry, etc.)
          "setup.py",         -- Python setup  -- Custom (crée ce fichier vide dans n'importe quel dossier pour le marquer comme projet)
        },

        -- ========================================================================
        -- CHANGEMENT DE RÉPERTOIRE (CWD)
        -- ========================================================================
        -- true  : Change automatiquement le CWD quand tu ouvres/changes de projet
        -- false : Liste juste les projets sans changer le CWD
        silent_chdir = true,

        -- ========================================================================
        -- SCOPE (portée du changement de CWD)
        -- ========================================================================
        -- "global" : Change le CWD pour toute la session Neovim (recommandé)
        -- "tab"    : Chaque tab peut être dans un projet différent
        -- "win"    : Chaque fenêtre peut être dans un projet différent
        scope_chdir = "global",

        -- ========================================================================
        -- FICHIERS/DOSSIERS CACHÉS
        -- ========================================================================
        -- false : N'affiche pas les projets dans les dossiers cachés (.config, .cache, etc.)
        -- true  : Affiche aussi les projets cachés
        show_hidden = false,

        -- ========================================================================
        -- MODE MANUEL
        -- ========================================================================
        -- false : Détection automatique (recommandé)
        -- true  : Change de projet seulement quand tu le demandes explicitement
        manual_mode = false,

        -- ========================================================================
        -- DATAPATH (historique des projets)
        -- ========================================================================
        -- Emplacement où sont sauvegardés les projets récents
        -- Par défaut : ~/.local/share/nvim/project_nvim/project_history
        datapath = vim.fn.stdpath("data"),

        -- ========================================================================
        -- EXCLUSIONS (dossiers à ignorer)
        -- ========================================================================
        -- Évite de détecter des "faux" projets dans les dossiers système
        exclude_dirs = {
          "~/.cache",
          "~/.local/share/nvim",
          "~/.cargo",
          "~/.rustup",
          "~/.npm",
          "~/.nvm",
          "~/.zsh",
          "~/node_modules",
          "*/node_modules/*",
          "*/tmp/*",
          "/tmp/*",
        },
      })

      -- ============================================================================
      -- INTÉGRATION TELESCOPE
      -- ============================================================================
      -- Charge l'extension "projects" pour Telescope
      -- Permet d'utiliser :Telescope projects (ou <leader>fp)
      require("telescope").load_extension("projects")

      -- ============================================================================
      -- HIGHLIGHTS (couleurs Dracula)
      -- ============================================================================
      -- Personnalisation des couleurs dans Telescope projects
      vim.api.nvim_set_hl(0, "TelescopeProjectsTitle", { fg = "#BD93F9", bold = true }) -- Violet
      vim.api.nvim_set_hl(0, "TelescopeProjectsPath", { fg = "#8BE9FD" })               -- Cyan
    end,
  },
}

-- ============================================================================
-- NOTES D'UTILISATION
-- ============================================================================
-- Commandes disponibles :
--   :Telescope projects     - Afficher liste des projets (ou <leader>fp)
--   :ProjectRoot            - Afficher la racine du projet actuel
--
-- Comportement :
--   1. Tu ouvres un fichier : nvim ~/42/libft/src/ft_strlen.c
--   2. Le plugin détecte automatiquement la racine : ~/42/libft/ (car trouve .git ou Makefile)
--   3. Le CWD change automatiquement : :pwd → ~/42/libft/
--   4. Telescope, LSP, terminal sont maintenant dans le contexte du projet
--
-- Changer de projet :
--   1. <leader>fp (ou :Telescope projects)
--   2. Sélectionne un projet dans la liste
--   3. Le CWD change automatiquement
--   4. Les anciens buffers se ferment (optionnel selon config session)
--   5. Tu es maintenant dans le nouveau projet
--
-- Historique :
--   - Les projets récemment ouverts sont sauvegardés
--   - Affichés en premier dans :Telescope projects
--   - Fichier : ~/.local/share/nvim/project_nvim/project_history
--
-- Ajouter un projet custom :
--   Si un dossier n'a ni .git ni Makefile ni package.json :
--   1. cd /ton/dossier
--   2. touch .projectroot
--   3. Neovim détectera maintenant ce dossier comme un projet
--
-- Exemples de projets détectés pour toi :
--   ~/42/libft/           → Détecté via .git ou Makefile
--   ~/42/get_next_line/   → Détecté via .git ou Makefile
--   ~/42/push_swap/       → Détecté via .git ou Makefile
--   ~/web/portfolio/      → Détecté via .git ou package.json
--   ~/web/client-site/    → Détecté via .git ou package.json
--
-- Intégration avec Dashboard BIZZON :
--   Le bouton "Projects" (p) dans le dashboard utilisera :Telescope projects
--
-- Intégration avec auto-session (à venir) :
--   Quand tu changes de projet, la session du projet précédent est sauvegardée
--   Quand tu reviens sur un projet, sa session est restaurée
--
-- Performance :
--   - Lazy-load (VeryLazy) : Ne charge pas au démarrage
--   - Détection rapide (pattern matching simple)
--   - Pas de ralentissement perceptible
-- ============================================================================
