-- ============================================================================
-- FLASH.LUA - Navigation ultra-rapide
-- ============================================================================
-- Description: Sauter instantanément n'importe où à l'écran
-- Plugin: folke/flash.nvim
-- ============================================================================

return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    -- Modes de recherche
    modes = {
      -- Mode search (s en normal)
      search = {
        enabled = true,
        -- Saut en avant avec 's', en arrière avec 'S'
        forward = true,
        wrap = true,
        multi_window = true, -- Recherche dans toutes les fenêtres visibles
      },
      -- Mode char (f, F, t, T améliorés)
      char = {
        enabled = true,
        -- Améliore f, F, t, T natifs de vim
        keys = { "f", "F", "t", "T" },
        search = { wrap = false },
        highlight = { backdrop = true },
        multi_line = true,
      },
      -- Mode treesitter (sauter entre fonctions, classes, etc.)
      treesitter = {
        enabled = true,
        labels = "abcdefghijklmnopqrstuvwxyz",
        jump = { pos = "range" },
      },
    },

    -- Apparence des labels
    label = {
      uppercase = false, -- Labels en minuscules (plus rapide à taper)
      rainbow = {
        enabled = true, -- Couleurs différentes pour les labels
        shade = 5,
      },
    },

    -- Style de surbrillance
    highlight = {
      backdrop = true, -- Assombrit le reste du texte
      matches = true,  -- Surligne les matchs
    },

    -- Labels utilisés (ordre de préférence)
    labels = "asdfghjklqwertyuiopzxcvbnm",

    -- Recherche
    search = {
      multi_window = true,  -- Cherche dans toutes les fenêtres
      forward = true,       -- Direction par défaut
      wrap = true,          -- Boucle en fin de fichier
      mode = "fuzzy",       -- "exact" ou "fuzzy" ou "search"
    },

    -- Jump
    jump = {
      jumplist = true,      -- Ajoute aux jumplist (Ctrl-o pour revenir)
      pos = "start",        -- Position du curseur ("start", "end", "range")
      history = true,       -- Garde l'historique des sauts
      register = false,     -- Ne pas utiliser de registre
      nohlsearch = false,   -- Garde le highlight de recherche
      autojump = false,     -- Saute automatiquement s'il n'y a qu'un seul match
    },
  },

  keys = {
    -- Navigation principale
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash jump",
    },

    -- Navigation en arrière
    {
      "S",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump({ search = { forward = false } })
      end,
      desc = "Flash jump backward",
    },

    -- Treesitter jump (sauter entre fonctions, classes, etc.)
    {
      "<leader>j",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },

    -- Remote flash (pour opérations: d, c, y, etc.)
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },

    -- Sélection Treesitter
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Treesitter Search",
    },

    -- Toggle flash search dans la recherche normale
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },
}

-- ============================================================================
-- UTILISATION
-- ============================================================================
--
-- Navigation de base:
--   s          → Flash jump (en avant)
--   S          → Flash jump (en arrière)
--   <leader>j  → Jump vers fonctions/classes (Treesitter)
--
-- Mouvements améliorés (automatiques):
--   f/F/t/T    → Améliorés avec Flash (multi-ligne)
--
-- Opérations à distance (operator-pending):
--   d + r      → Delete avec Flash (tape les lettres, puis le label)
--   c + r      → Change avec Flash
--   y + r      → Yank avec Flash
--
-- Dans la recherche (mode commande):
--   / ou ?     → Recherche normale
--   <C-s>      → Active/désactive Flash pendant la recherche
--
-- Exemples:
--   s + "fu" + a    → Saute au premier "fu" (label 'a')
--   d + r + "re" + b → Supprime jusqu'au "re" marqué 'b'
--   <leader>j       → Affiche toutes les fonctions et saute
--
-- ============================================================================
