-- ============================================================================
-- DASHBOARD.LUA - Dashboard d'accueil BIZZON
-- ============================================================================
-- Description: Dashboard d'accueil avec ASCII art BIZZON et navigation rapide
-- Plugins: alpha-nvim (dashboard)
-- Note: Les autres plugins UI (statusline, bufferline, etc.) seront dans ui.lua
-- ============================================================================

return {
  -- ============================================================================
  -- ALPHA-NVIM - Dashboard BIZZON 🦬
  -- ============================================================================
  {
    "goolord/alpha-nvim",
    event = "VimEnter", -- Charge au démarrage de Neovim
    dependencies = {
      "nvim-tree/nvim-web-devicons",     -- Icônes Nerd Font
      "nvim-telescope/telescope.nvim",   -- Pour les actions des boutons
      "folke/persistence.nvim",          -- Pour le bouton Restore Session
    },

    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- ============================================================================
      -- HEADER : ASCII ART BIZZON (Option 2 - avec sous-titre)
      -- ============================================================================
      dashboard.section.header.val = {
        "",
        "",
        "██████╗ ██╗   ██╗    ███████╗███████╗██╗      ██████╗ ██╗  ██╗██╗  ██╗",
        "██╔══██╗╚██╗ ██╔╝    ╚══███╔╝██╔════╝██║     ██╔═══██╗╚██╗██╔╝╚██╗██╔╝",
        "██████╔╝ ╚████╔╝       ███╔╝ █████╗  ██║     ██║   ██║ ╚███╔╝  ╚███╔╝ ",
        "██╔══██╗  ╚██╔╝       ███╔╝  ██╔══╝  ██║     ██║   ██║ ██╔██╗  ██╔██╗ ",
        "██████╔╝   ██║       ███████╗███████╗███████╗╚██████╔╝██╔╝ ██╗██╔╝ ██╗",
        "╚═════╝    ╚═╝       ╚══════╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝",
        "",
        "        🦬 Power, Resilience, Code 🦬         ",
        "",
      }
      dashboard.section.header.opts.hl = "DashboardHeader"

      -- ============================================================================
      -- BOUTONS : Actions rapides avec icônes Nerd Font
      -- ============================================================================
      -- ⚠️  ICÔNES À REMPLIR : Remplace les "  " par tes icônes Nerd Font
      -- Site : https://www.nerdfonts.com/cheat-sheet
      -- Copie l'icône directement depuis le site et colle-la dans les "  "

      dashboard.section.buttons.val = {
        -- ========================================================================
        -- Find File (f)
        -- Mots-clés icône : search, file, find, magnify, document
        -- Exemples : 󰈞 󰍉 󰱼
        -- ========================================================================
        dashboard.button("f", " 󰮗  Find File", ":Telescope find_files<CR>"),

        -- ========================================================================
        -- New File (n)
        -- Mots-clés icône : new, file, plus, add, create
        -- Exemples :
        -- ========================================================================
        dashboard.button("n", "   New File", ":enew<CR>"),

        -- ========================================================================
        -- Recent Files (r)
        -- Mots-clés icône : recent, clock, history, time, oldfiles
        -- Exemples :
        -- ========================================================================
        dashboard.button("r", "   Recent Files", ":Telescope oldfiles<CR>"),

        -- ========================================================================
        -- Find Text (g) - grep
        -- Mots-clés icône : search, text, grep, telescope, find
        -- Exemples :
        -- ========================================================================
        dashboard.button("g", "   Find Text", ":Telescope live_grep<CR>"),

        -- ========================================================================
        -- Restore Session (s)
        -- Mots-clés icône : restore, history, reload, backup, session
        -- Exemples : 󰦛 󰁯
        -- ========================================================================
        dashboard.button("s", " 󰦛  Restore Session", ":lua _G.safe_load_session()<CR>"),

        -- ========================================================================
        -- Projects (p)
        -- Mots-clés icône : project, folder, briefcase, directory
        -- Exemples :
        -- ========================================================================
        dashboard.button("p", "   Projects", ":Telescope projects<CR>"),

        -- ========================================================================
        -- Keymaps (k)
        -- Mots-clés icône : keyboard, key, shortcut, mapping
        -- Exemples : 󰌌
        -- ========================================================================
        dashboard.button("k", "   Keymaps", ":Telescope keymaps<CR>"),


        -- ========================================================================
        -- Lazy (l) - Plugin manager
        -- Mots-clés icône : package, plugin, box, cube, lazy
        -- Exemples : 󰏖
        -- ========================================================================
        dashboard.button("l", "   Lazy Plugins", ":Lazy<CR>"),

        -- ========================================================================
        -- Quit (q)
        -- Mots-clés icône : exit, quit, close, power, door
        -- Exemples :
        -- ========================================================================
        dashboard.button("q", " 󰈆  Quit", ":qa<CR>"),
      }

      -- ============================================================================
      -- FOOTER : Stats dynamiques (nombre de plugins, temps de démarrage)
      -- ============================================================================
      dashboard.section.footer.val = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        return {
          "",
          "⚡ Neovim chargé en " .. ms .. "ms avec " .. stats.count .. " plugins",
        }
      end
      dashboard.section.footer.opts.hl = "DashboardFooter"

      -- ============================================================================
      -- LAYOUT : Espacement et positionnement
      -- ============================================================================
      -- Configure l'espacement entre les sections (responsive automatique)
      dashboard.config.layout = {
        { type = "padding", val = 2 },     -- Espace avant le header
        dashboard.section.header,          -- Header BIZZON
        { type = "padding", val = 2 },     -- Espace entre header et boutons
        dashboard.section.buttons,         -- Boutons
        { type = "padding", val = 1 },     -- Espace entre boutons et footer
        dashboard.section.footer,          -- Footer avec stats
      }

      -- Options générales du dashboard
      dashboard.config.opts.noautocmd = true

      -- ============================================================================
      -- COULEURS DRACULA
      -- ============================================================================
      -- Palette Dracula officielle
      local colors = {
        bg = "#282A36",      -- Background sombre
        fg = "#F8F8F2",      -- Foreground blanc
        selection = "#44475A", -- Sélection
        comment = "#6272A4", -- Commentaires
        red = "#FF5555",     -- Rouge
        orange = "#FFB86C",  -- Orange
        yellow = "#F1FA8C",  -- Jaune
        green = "#50FA7B",   -- Vert
        purple = "#BD93F9",  -- Violet (signature Dracula)
        cyan = "#8BE9FD",    -- Cyan
        pink = "#FF79C6",    -- Rose/Pink
      }

      -- Appliquer les couleurs au dashboard
      vim.api.nvim_set_hl(0, "DashboardHeader", { fg = colors.purple, bold = true })   -- Header BIZZON (violet)
      vim.api.nvim_set_hl(0, "DashboardCenter", { fg = colors.fg })                    -- Texte boutons (blanc)
      vim.api.nvim_set_hl(0, "DashboardShortCut", { fg = colors.pink, bold = true })   -- Raccourcis lettres (rose)
      vim.api.nvim_set_hl(0, "DashboardFooter", { fg = colors.green })                 -- Footer stats (vert)
      vim.api.nvim_set_hl(0, "DashboardIcon", { fg = colors.cyan })                    -- Icônes (cyan)

      -- ============================================================================
      -- SETUP ALPHA
      -- ============================================================================
      alpha.setup(dashboard.config)

      -- ============================================================================
      -- AUTO-COMMANDES : UI propre dans le dashboard
      -- ============================================================================
      -- Quand le dashboard s'affiche
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          vim.opt.showtabline = 0  -- Cache la tabline
          vim.opt.laststatus = 0   -- Cache la statusline (barre en bas)
          vim.opt.cmdheight = 0    -- Cache la ligne de commande
        end,
      })

      -- Quand on quitte le dashboard (ouvre un fichier)
      vim.api.nvim_create_autocmd("BufUnload", {
        buffer = 0,
        callback = function()
          vim.opt.showtabline = 2  -- Réaffiche la tabline
          vim.opt.laststatus = 3   -- Réaffiche la statusline
          vim.opt.cmdheight = 0    -- Garde cmdheight à 0 (comme LazyVim)
        end,
      })

      -- Désactive certaines options gênantes dans le dashboard
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "alpha",
        callback = function()
          vim.opt_local.foldenable = false
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.cursorline = false
        end,
      })

      -- ========================================================================
      -- AUTO-COMMANDES
      -- ========================================================================
      -- Quand le dashboard s'affiche
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          vim.opt.showtabline = 0
          vim.opt.laststatus = 0
          vim.opt.cmdheight = 0
        end,
      })

      -- Quand on quitte le dashboard
      vim.api.nvim_create_autocmd("BufUnload", {
        buffer = 0,
        callback = function()
          vim.opt.showtabline = 2
          vim.opt.laststatus = 3
          vim.opt.cmdheight = 0
        end,
      })
    end,
  },
}

-- ============================================================================
-- NOTES D'UTILISATION
-- ============================================================================
-- Lancement :
--   nvim              → Dashboard s'affiche
--   nvim fichier.c    → Ouvre directement le fichier (pas de dashboard)
--
-- Navigation dans le dashboard :
--   j / k             → Monter/Descendre entre les boutons
--   <Down> / <Up>     → Pareil
--   <Enter>           → Exécuter le bouton sélectionné
--
-- Raccourcis directs (sans navigation) :
--   f  → Find File (Telescope find_files)
--   n  → New File (nouveau buffer)
--   r  → Recent Files (Telescope oldfiles)
--   g  → Find Text (Telescope live_grep)
--   s  → Restore Session (SessionRestore)
--   p  → Projects (Telescope projects)
--   k  → Keymaps (Telescope keymaps)
--   l  → Lazy Plugins (ouvre Lazy)
--   q  → Quit (quitter Neovim)
--
-- Fermer le dashboard :
--   :q  ou  :bd       → Ferme le dashboard et affiche un buffer vide
--
-- Icônes Nerd Font :
--   1. Va sur : https://www.nerdfonts.com/cheat-sheet
--   2. Cherche ton icône (ex: "search file")
--   3. Clique sur l'icône → Copie
--   4. Colle dans les champs "  " de ce fichier
--   5. Sauvegarde et relance Neovim
--
-- Exemple d'icônes (si tu as une Nerd Font) :
--   Find File      : 󰈞  ou   ou
--   New File       :   ou   ou
--   Recent Files   :   ou   ou
--   Find Text      :   ou   ou
--   Restore Session: 󰦛  ou 󰁯  ou
--   Projects       :   ou   ou
--   Keymaps        : 󰌌  ou   ou
--   Config         :   ou   ou
--   Lazy           : 󰏖  ou   ou
--   Quit           :   ou   ou
--
-- Couleurs Dracula :
--   Header BIZZON     : Violet #BD93F9 (signature Dracula)
--   Sous-titre 🦬     : Cyan #8BE9FD (intégré dans le header)
--   Icônes            : Cyan #8BE9FD
--   Texte boutons     : Blanc #F8F8F2
--   Raccourcis (f,n..) : Rose #FF79C6
--   Footer stats      : Vert #50FA7B
--
-- Intégration avec les autres plugins :
--   ✅ telescope.lua  → Boutons f, r, g, k, p
--   ✅ session.lua    → Bouton s
--   ✅ project.lua    → Bouton p (via Telescope)
--   ✅ lazy.nvim      → Bouton l + footer stats
--
-- Comportement au démarrage :
--   CAS 1 : nvim (sans args, pas dans un projet)
--     → Dashboard BIZZON s'affiche ✅
--
--   CAS 2 : nvim fichier.c
--     → Ouvre fichier.c directement (pas de dashboard) ✅
--
--   CAS 3 : nvim (dans un projet avec session sauvegardée)
--     → Dashboard s'affiche (car auto_restore = false dans session.lua)
--     → Bouton "Restore Session" (s) disponible pour reprendre ✅
--
-- Responsive :
--   - Petit écran (laptop 13") : Tout tient, bien centré
--   - Grand écran (27"+) : Centré aussi, pas étiré
--   - Resize terminal : Recalcule automatiquement
--
-- Performance :
--   - Charge uniquement au VimEnter
--   - Pas de ralentissement
--   - Footer dynamique (temps réel)
--
-- Customisation :
--   - Pour changer l'espacement : Modifie les valeurs "padding"
--   - Pour changer les couleurs : Modifie la section COULEURS DRACULA
--   - Pour ajouter/supprimer boutons : Modifie dashboard.section.buttons.val
--   - Pour changer le header : Modifie dashboard.section.header.val
--
-- Tips :
--   - Si tu n'aimes pas le dashboard : Commente tout ce fichier
--   - Si tu veux un autre ASCII art : Remplace le header
--   - Si tu veux d'autres couleurs : Modifie les highlights
--
-- Workflow recommandé au quotidien :
--   1. Lance Neovim : nvim
--   2. Dashboard BIZZON apparaît
--   3. Choisis une action :
--      - 'f' pour trouver un fichier
--      - 'r' pour reprendre un fichier récent
--      - 's' pour restaurer ta dernière session
--      - 'p' pour changer de projet
--   4. Travaille normalement
--   5. Quitte : :qa (session auto-sauvegardée)
--   6. Lendemain, relance : nvim → Dashboard → 's' pour reprendre ✅
-- ============================================================================
