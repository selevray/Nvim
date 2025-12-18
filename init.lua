-- ============================================================================
-- init.lua - Point d'entrée de la configuration Neovim
-- ============================================================================
-- Ce fichier est le premier exécuté par Neovim au démarrage.
-- Il charge tous les autres modules dans le bon ordre.

-- Définir le leader key AVANT tout le reste
-- Le leader est une touche spéciale pour les raccourcis personnalisés
-- Par défaut c'est '\' mais on utilise souvent espace ou ','
vim.g.mapleader = " "        -- Leader = barre d'espace
vim.g.maplocalleader = " "   -- Leader local (pour certains filetypes)

-- Charger les options globales de Neovim
require("config.options")

-- Initialiser le plugin manager
require("config.lazy")

-- Charger les raccourcis clavier
require("config.keymaps")

-- Charger les automatisations
require("config.autocmds")
