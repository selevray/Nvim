-- ============================================================================
-- PERSISTENCE.LUA - Gestion intelligente des sessions Neovim
-- ============================================================================
-- Description: Auto-sauvegarde et restauration de sessions par projet
-- Plugin: folke/persistence.nvim
-- Stratégie: Git-first avec fallback sur working directory
-- ============================================================================

return {
  -- ============================================================================
  -- PERSISTENCE.NVIM - Session Manager by folke 🦬
  -- ============================================================================
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- Charge avant de lire un buffer

    opts = {
      -- ========================================================================
      -- CONFIGURATION DE BASE
      -- ========================================================================

      -- Répertoire de stockage des sessions
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),

      -- Options Vim à sauvegarder dans la session
      -- Correspond aux flags de :mksession
      options = {
        "buffers",       -- Tous les buffers (pas seulement ceux avec des fichiers)
        "curdir",        -- Working directory actuel
        "tabpages",      -- Tous les tabs
        "winsize",       -- Taille des fenêtres
        "help",          -- Fenêtres d'aide
        "globals",       -- Variables globales qui commencent par une majuscule
        "skiprtp",       -- Exclut 'runtimepath' et 'packpath'
        "folds",         -- Pliages de code
        "winpos",        -- Position de la fenêtre
      },

      -- ========================================================================
      -- HOOKS : Nettoyage avant sauvegarde
      -- ========================================================================

      -- Fonction exécutée AVANT de sauvegarder la session
      -- Utilisée pour nettoyer les buffers indésirables
      pre_save = function()
        -- Liste des types de buffers à fermer avant sauvegarde
        local buftypes_to_close = {
          "quickfix",      -- Quickfix list
          "help",          -- Fenêtres d'aide
          "nofile",        -- Buffers sans fichier
          "terminal",      -- Terminaux
          "prompt",        -- Buffers de type prompt
        }

        -- Liste des filetypes de plugins à fermer
        local filetypes_to_close = {
          -- File explorers
          "neo-tree",
          "NvimTree",
          "oil",

          -- Fuzzy finders
          "TelescopePrompt",
          "TelescopeResults",
          "telescope",

          -- Plugin UIs
          "lazy",
          "mason",
          "alpha",         -- Dashboard
          "dashboard",
          "starter",

          -- Git
          "fugitive",
          "git",
          "gitcommit",

          -- Debugging
          "dap-repl",
          "dapui_watches",
          "dapui_stacks",
          "dapui_breakpoints",
          "dapui_scopes",
          "dapui_console",

          -- Autres
          "notify",        -- Notifications
          "trouble",       -- Trouble.nvim
          "qf",            -- Quickfix
          "help",
          "man",
          "lspinfo",
          "checkhealth",
        }

        -- Parcourir tous les buffers et fermer ceux qui matchent
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) then
            local buftype = vim.bo[buf].buftype
            local filetype = vim.bo[buf].filetype

            -- Fermer si le buftype match
            if vim.tbl_contains(buftypes_to_close, buftype) then
              pcall(vim.api.nvim_buf_delete, buf, { force = true })
            end

            -- Fermer si le filetype match
            if vim.tbl_contains(filetypes_to_close, filetype) then
              pcall(vim.api.nvim_buf_delete, buf, { force = true })
            end

            -- Fermer les buffers sans nom (scratch buffers)
            local name = vim.api.nvim_buf_get_name(buf)
            if name == "" and buftype == "" then
              pcall(vim.api.nvim_buf_delete, buf, { force = true })
            end
          end
        end
      end,

      -- ========================================================================
      -- STRATÉGIE DE SESSION : Git-first + Working Directory
      -- ========================================================================

      -- Fonction pour déterminer le nom/path de la session
      -- Par défaut persistence utilise vim.fn.getcwd(), on le surcharge
      -- Note: Cette option n'existe pas nativement, on utilisera get_session_dir()

    },

    -- ========================================================================
    -- CONFIGURATION AVANCÉE
    -- ========================================================================
    config = function(_, opts)
      local persistence = require("persistence")
      persistence.setup(opts)

      -- ======================================================================
      -- STRATÉGIE INTELLIGENTE : Git-first avec fallback
      -- ======================================================================

      -- Fonction pour trouver la racine git
      local function find_git_root()
        local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        if vim.v.shell_error == 0 and git_root and git_root ~= "" then
          return git_root
        end
        return nil
      end

      -- Fonction pour vérifier si le répertoire doit être ignoré
      local function should_ignore_dir(dir)
        -- Normaliser le chemin
        local normalized = vim.fn.expand(dir)

        -- Patterns à ignorer (pas de session)
        local ignore_patterns = {
          "^/tmp",                                    -- Temporaires
          "^/var",                                    -- Système
          "^/usr",                                    -- Système
          "^/etc",                                    -- Système
          "/Downloads$",                              -- Téléchargements
          "/Downloads/",
          "%.cache",                                  -- Cache
          "%.local/share/nvim",                       -- Data Neovim
          "node_modules",                             -- Dépendances
        }

        for _, pattern in ipairs(ignore_patterns) do
          if normalized:match(pattern) then
            return true
          end
        end

        return false
      end

      -- Fonction pour déterminer le répertoire de session
      local function get_session_dir()
        -- 1. Vérifier si fichier isolé (Neovim lancé avec des arguments)
        local argc = vim.fn.argc()
        if argc > 0 then
          -- Fichiers passés en arguments = pas de session auto
          return nil
        end

        -- 2. Chercher racine git en priorité
        local git_root = find_git_root()
        if git_root then
          if not should_ignore_dir(git_root) then
            return git_root
          else
            return nil -- Dossier ignoré
          end
        end

        -- 3. Fallback sur working directory
        local cwd = vim.fn.getcwd()
        if not should_ignore_dir(cwd) then
          return cwd
        end

        -- 4. Aucune session (dossier ignoré ou fichier isolé)
        return nil
      end

      -- ======================================================================
      -- AUTO-COMMANDES : Sauvegarde et Restauration
      -- ======================================================================

      -- Variable pour tracker si on doit sauvegarder
      local should_save = true

      -- Fonction pour désactiver la sauvegarde
      _G.disable_session_save = function()
        should_save = false
        vim.notify("Session auto-save désactivée", vim.log.levels.INFO)
      end

      -- Auto-sauvegarde à la sortie de Neovim (si session valide)
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = vim.api.nvim_create_augroup("PersistenceSave", { clear = true }),
        callback = function()
          if should_save and get_session_dir() then
            -- Sauvegarder la session
            pcall(persistence.save)
          end
        end,
      })

      -- ======================================================================
      -- NOTIFICATIONS : Uniquement les erreurs
      -- ======================================================================

      -- Wrapper pour persistence.load avec gestion d'erreurs
      _G.safe_load_session = function()
        local ok, err = pcall(persistence.load)
        if not ok then
          vim.notify("Erreur lors du chargement de la session: " .. tostring(err), vim.log.levels.ERROR)
        end
      end

      -- Wrapper pour persistence.save avec gestion d'erreurs
      _G.safe_save_session = function()
        local session_dir = get_session_dir()
        if not session_dir then
          vim.notify("Aucune session à sauvegarder (dossier ignoré ou fichier isolé)", vim.log.levels.WARN)
          return
        end

        local ok, err = pcall(persistence.save)
        if not ok then
          vim.notify("Erreur lors de la sauvegarde de la session: " .. tostring(err), vim.log.levels.ERROR)
        end
      end
    end,

    -- ========================================================================
    -- KEYMAPS : Navigation de sessions
    -- ========================================================================
    keys = {
      {
        "<leader>qs",
        function()
          _G.safe_save_session()
        end,
        desc = "💾 Sauvegarder session",
      },
      {
        "<leader>ql",
        function()
          _G.safe_load_session()
        end,
        desc = "📂 Charger dernière session",
      },
      {
        "<leader>qd",
        function()
          _G.disable_session_save()
        end,
        desc = "🚫 Désactiver auto-save session",
      },
    },
  },
}

-- ============================================================================
-- NOTES D'UTILISATION
-- ============================================================================
-- Comportement automatique :
--   nvim                    → Affiche le dashboard (pas de restauration auto)
--   nvim fichier.lua        → Ouvre fichier.lua directement
--   nvim (dans /tmp)        → Pas de session (dossier ignoré)
--
-- Keymaps :
--   <leader>qs              → Sauvegarder manuellement la session
--   <leader>ql              → Charger la dernière session
--   <leader>qd              → Désactiver l'auto-save pour cette instance
--
-- Stratégie de session :
--   1. Git repository       → Session basée sur racine git (priorité)
--   2. Working directory    → Session basée sur dossier courant (fallback)
--   3. Fichier isolé        → Pas de session
--   4. Dossier ignoré       → Pas de session
--
-- Dossiers ignorés :
--   /tmp/*                  → Fichiers temporaires
--   ~/Downloads             → Téléchargements
--   /usr, /etc, /var        → Système
--   ~/.cache                → Cache
--   ~/.local/share/nvim     → Data Neovim
--   node_modules            → Dépendances
--
-- Ce qui est sauvegardé :
--   ✅ Buffers ouverts (fichiers)
--   ✅ Layout des fenêtres (splits, tabs)
--   ✅ Positions des curseurs
--   ✅ Folds (pliages)
--   ✅ Working directory
--
-- Ce qui N'est PAS sauvegardé :
--   ❌ Buffers temporaires (help, quickfix, terminal)
--   ❌ UI de plugins (Telescope, Lazy, Neo-tree, etc.)
--   ❌ Buffers sans nom
--
-- Notifications :
--   🔕 Silencieux en temps normal
--   ⚠️  Alertes uniquement en cas d'erreur
--
-- Intégration Dashboard :
--   Le bouton "Restore Session" (s) dans dashboard.lua appelle :
--   :lua _G.safe_load_session()
--
-- Stockage :
--   Les sessions sont sauvegardées dans :
--   ~/.local/state/nvim/sessions/
--
-- Debugging :
--   Pour voir quelle session serait utilisée :
--   :lua print(vim.fn.getcwd())
--   :lua print(vim.fn.systemlist("git rev-parse --show-toplevel")[1])
--
-- Tips :
--   - Si la session ne se restaure pas : vérifiez que vous êtes dans un projet
--   - Si vous voulez forcer la restauration : <leader>ql
--   - Si vous voulez sauvegarder manuellement : <leader>qs
--   - Si vous ne voulez pas sauvegarder cette session : <leader>qd
--
-- Workflow recommandé :
--   1. cd ~/projets/mon-app
--   2. nvim
--   3. Travaillez normalement
--   4. :qa (session auto-sauvegardée)
--   5. Lendemain : cd ~/projets/mon-app && nvim (session restaurée ✅)
-- ============================================================================
