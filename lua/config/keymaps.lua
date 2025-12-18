-- ============================================================================
-- KEYMAPS.LUA - Configuration des raccourcis clavier pour Neovim
-- ============================================================================
-- Inspiré de LazyVim, AstroVim et NvChad
-- Organisation logique par catégories

-- Définir le leader key (doit être défini AVANT les autres keymaps)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Fonction helper pour les keymaps
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }


vim.keymap.set('i', '<F13>', '<Esc>', { noremap = true })
vim.keymap.set('v', '<F13>', '<Esc>', { noremap = true })
-- ============================================================================
-- 💾 FICHIERS & BUFFERS
-- ============================================================================

-- Sauvegarder
keymap({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Sauvegarder fichier" })

-- Sauvegarder tout
keymap("n", "<C-S-s>", "<cmd>wa<cr>", { desc = "Sauvegarder tous les fichiers" })

-- Nouveau fichier
keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "Nouveau fichier" })

-- Copier chemin du fichier
keymap("n", "<leader>fy", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify('Copié: ' .. path, vim.log.levels.INFO)
end, { desc = "Copier chemin absolu du fichier" })

keymap("n", "<leader>fY", function()
  local path = vim.fn.expand("%:t")
  vim.fn.setreg("+", path)
  vim.notify('Copié: ' .. path, vim.log.levels.INFO)
end, { desc = "Copier nom du fichier" })

-- Fermer buffer avec confirmation si modifié
keymap("n", "<leader>q", "<leader>bd", { desc = "Fermer buffer", remap = true })

-- -- Forcer fermer buffer (même non sauvegardé)
-- keymap("n", "<leader>qq", "<cmd>bd!<cr>", { desc = "Forcer fermer buffer" })

-- Sauvegarder et fermer buffer
keymap("n", "<leader>x", "<cmd>x<cr>", { desc = "Sauvegarder et fermer buffer" })

-- Quitter Neovim
keymap("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quitter Neovim" })

-- Navigation entre buffers
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Buffer précédent" })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Buffer suivant" })

-- ============================================================================
-- 🪟 FENÊTRES (SPLITS)
-- ============================================================================

-- Navigation entre fenêtres
keymap("n", "<C-h>", "<C-w>h", { desc = "Aller à la fenêtre gauche" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Aller à la fenêtre bas" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Aller à la fenêtre haut" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Aller à la fenêtre droite" })

-- Redimensionner fenêtres
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Augmenter hauteur" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Diminuer hauteur" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Diminuer largeur" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Augmenter largeur" })

-- Créer des splits
keymap("n", "<leader>-", "<C-w>s", { desc = "Split horizontal" })
keymap("n", "<leader>|", "<C-w>v", { desc = "Split vertical" })

-- Gestion des fenêtres (LazyVim style)
keymap("n", "<leader>wd", "<C-w>c", { desc = "Fermer fenêtre" })
keymap("n", "<leader>wo", "<C-w>o", { desc = "Fermer les autres fenêtres" })

-- ============================================================================
-- ✏️ ÉDITION
-- ============================================================================

-- Déplacer des lignes
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Déplacer ligne vers le bas" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Déplacer ligne vers le haut" })
keymap("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Déplacer ligne vers le bas" })
keymap("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Déplacer ligne vers le haut" })
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Déplacer sélection vers le bas" })
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Déplacer sélection vers le haut" })
keymap("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Déplacer sélection vers le bas" })
keymap("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Déplacer sélection vers le haut" })

-- Dupliquer des lignes
keymap("n", "<S-A-j>", "yyp", { desc = "Dupliquer ligne en dessous" })
keymap("n", "<S-A-k>", "yyP", { desc = "Dupliquer ligne au dessus" })
keymap("n", "<S-A-Down>", "yyp", { desc = "Dupliquer ligne en dessous" })
keymap("n", "<S-A-Up>", "yyP", { desc = "Dupliquer ligne au dessus" })
keymap("v", "<S-A-j>", "y`>pgv", { desc = "Dupliquer sélection en dessous" })
keymap("v", "<S-A-k>", "y`<Pgv", { desc = "Dupliquer sélection au dessus" })
keymap("v", "<S-A-Down>", "y`>pgv", { desc = "Dupliquer sélection en dessous" })
keymap("v", "<S-A-Up>", "y`<Pgv", { desc = "Dupliquer sélection au dessus" })

-- Indentation (garde la sélection en mode visuel)
keymap("v", "<", "<gv", { desc = "Indenter à gauche" })
keymap("v", ">", ">gv", { desc = "Indenter à droite" })

-- Supprimer sans copier (black hole register)
keymap({ "n", "v" }, "<leader>D", '"_d', { desc = "Supprimer sans copier" })

-- Commentaires (nécessite Comment.nvim ou similaire)
-- gcc et gc sont gérés par le plugin, on ajoute juste un raccourci supplémentaire
keymap({ "n", "v" }, "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle commentaire" })

-- Joindre lignes (garde le curseur en place)
keymap("n", "J", "mzJ`z", { desc = "Joindre lignes" })

-- Incrémenter/Décrémenter nombres
keymap("n", "+", "<C-a>", { desc = "Incrémenter nombre" })
keymap("n", "-", "<C-x>", { desc = "Décrémenter nombre" })

-- ============================================================================
-- 📋 COPIER/COLLER
-- ============================================================================

-- Copier vers le clipboard système
keymap({ "n", "v" }, "<leader>y", '"+y', { desc = "Copier vers système" })

-- Coller depuis le clipboard système
keymap({ "n", "v" }, "<leader>p", '"+p', { desc = "Coller depuis système" })

-- Tout sélectionner
keymap("n", "<C-a>", "ggVG", { desc = "Tout sélectionner" })

-- ============================================================================
-- 🧭 NAVIGATION
-- ============================================================================

-- Navigation visuelle dans les lignes wrappées
keymap({ "n", "v" }, "j", "gj", { desc = "Descendre (visuel)" })
keymap({ "n", "v" }, "k", "gk", { desc = "Monter (visuel)" })

-- Navigation demi-page avec centrage
keymap("n", "<C-d>", "<C-d>zz", { desc = "Demi-page bas (centré)" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Demi-page haut (centré)" })

-- Recherche avec centrage et direction cohérente
keymap("n", "n", "'Nn'[v:searchforward].'zzzv'", { expr = true, desc = "Recherche suivante (centré)" })
keymap("n", "N", "'nN'[v:searchforward].'zzzv'", { expr = true, desc = "Recherche précédente (centré)" })

-- Clear search highlight
keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Effacer surbrillance" })

-- Ouvrir URL sous le curseur (fix du gx natif cassé)
keymap("n", "gx", function()
  local url = vim.fn.expand("<cfile>")
  if url:match("^https?://") then
    -- Détection de l'OS pour utiliser la bonne commande
    local open_cmd
    if vim.fn.has("mac") == 1 then
      open_cmd = "open"
    elseif vim.fn.has("unix") == 1 then
      open_cmd = "xdg-open"
    elseif vim.fn.has("win32") == 1 then
      open_cmd = "start"
    end
    if open_cmd then
      vim.fn.jobstart({ open_cmd, url }, { detach = true })
      vim.notify("Ouverture: " .. url, vim.log.levels.INFO)
    end
  else
    vim.notify("Pas d'URL détectée sous le curseur", vim.log.levels.WARN)
  end
end, { desc = "Ouvrir URL sous le curseur" })

-- Désactiver Q (mode Ex - personne ne l'utilise)
keymap("n", "Q", "<nop>", { desc = "Désactivé (mode Ex)" })

-- Navigation diagnostics (nécessite LSP)
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Diagnostic suivant" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnostic précédent" })
keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Ouvrir diagnostic détaillé" })

-- Navigation quickfix list
keymap("n", "]q", "<cmd>cnext<cr>", { desc = "Quickfix suivant" })
keymap("n", "[q", "<cmd>cprev<cr>", { desc = "Quickfix précédent" })
keymap("n", "<leader>xq", function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd "cclose"
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd "copen"
  end
end, { desc = "Toggle quickfix list" })

-- Navigation location list
keymap("n", "]l", "<cmd>lnext<cr>", { desc = "Location suivant" })
keymap("n", "[l", "<cmd>lprev<cr>", { desc = "Location précédent" })
keymap("n", "<leader>xl", function()
  local loc_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["loclist"] == 1 then
      loc_exists = true
    end
  end
  if loc_exists == true then
    vim.cmd "lclose"
    return
  end
  if not vim.tbl_isempty(vim.fn.getloclist(0)) then
    vim.cmd "lopen"
  end
end, { desc = "Toggle location list" })

-- ============================================================================
-- 🔍 RECHERCHE & FUZZY FINDING (nécessite Telescope)
-- ============================================================================
-- NOTE: Les keymaps Telescope sont définis dans lua/plugins/telescope.lua
-- pour profiter du lazy loading optimisé
-- ============================================================================
-- 🖥️ TERMINAL
-- ============================================================================

-- Ouvrir terminal
keymap("n", "<leader>th", "<cmd>split | terminal<cr>", { desc = "Terminal horizontal" })
keymap("n", "<leader>tv", "<cmd>vsplit | terminal<cr>", { desc = "Terminal vertical" })
keymap("n", "<leader>tf", "<cmd>terminal<cr>", { desc = "Terminal flottant" })

-- Toggle terminal rapide (nécessite un plugin comme toggleterm.nvim)
keymap("n", "<C-t>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })

-- Mode terminal : Esc pour sortir du mode insertion
keymap("t", "<Esc>", "<C-\\><C-n>", { desc = "Sortir mode terminal" })

-- ============================================================================
-- 🛠️ OUTILS
-- ============================================================================

-- Explorer de fichiers (nécessite neo-tree ou nvim-tree)
-- NOTE: Les keymaps Neo-tree sont définis dans lua/plugins/neo-tree.lua
-- pour profiter du lazy loading optimisé

-- Lazy (gestionnaire de plugins)
keymap("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
keymap("n", "<leader>L", "<cmd>Lazy update<cr>", { desc = "Lazy Update" })

-- Mason (gestionnaire de LSP/DAP/Linters/Formatters)
keymap("n", "<leader>m", "<cmd>Mason<cr>", { desc = "Mason" })

-- ============================================================================
-- 💻 LSP / CODE (nécessite LSP configuré)
-- ============================================================================

-- Navigation dans le code
keymap("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
keymap("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
keymap("n", "gI", vim.lsp.buf.implementation, { desc = "Go to implementation" })
keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })

-- Hover documentation
keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })

-- Code actions
keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

-- Rename
keymap("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Code rename" })

-- Format (nécessite conform.nvim ou formatter configuré)
keymap({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Code format" })

-- ============================================================================
-- 📝 NOTES
-- ============================================================================
-- Organisation des préfixes :
--   <leader>f  = Find (fichiers, buffers)
--   <leader>s  = Search (texte, keymaps, help)
--   <leader>c  = Code (format, actions, rename)
--   <leader>t  = Terminal
--   <leader>b  = Buffer (delete, etc.)
--   <leader>e  = Explorer
--   <leader>l  = Lazy
--
-- Certains keymaps nécessitent des plugins :
--   - Telescope (fuzzy finding)
--   - Comment.nvim (commentaires)
--   - LSP (code navigation, actions)
--   - Conform.nvim (formatage)
--   - Neo-tree ou nvim-tree (explorer)
--   - ToggleTerm (terminal)
-- ============================================================================
