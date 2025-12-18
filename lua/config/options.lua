-- ============================================================================
-- OPTIONS.LUA - Configuration Neovim
-- ============================================================================
-- Description: Options de base pour Neovim optimisées pour 42 et dev moderne
-- Langages: C, C++, Python, Shell, JS, TS
-- Basé sur: LazyVim, AstroNvim, NvChad best practices
-- ============================================================================

-- ============================================================================
-- SPLITS (FENÊTRES)

-- ============================================================================
-- APPARENCE ET INTERFACE
-- ============================================================================

-- Numérotation des lignes
vim.opt.number = true           -- Affiche les numéros de ligne absolus
vim.opt.relativenumber = true   -- Numéros relatifs (pratique pour 5j, 10k, etc.)
vim.opt.numberwidth = 2         -- Largeur minimale de la colonne de numéros (économise l'espace)

-- Curseur et ligne actuelle
vim.opt.cursorline = true       -- Surligne la ligne où se trouve le curseur
vim.opt.signcolumn = "yes"      -- Colonne pour git/diagnostics toujours visible (évite les "sauts")

-- Couleurs
vim.opt.termguicolors = true    -- Active les vraies couleurs 24-bit (16M couleurs)

-- Caractères invisibles
vim.opt.list = true             -- Affiche les caractères invisibles
vim.opt.listchars = {           -- Définit comment les afficher
  tab = "» ",                   -- Les TAB affichées avec "» "
  trail = "·",                  -- Espaces en fin de ligne (trailing spaces - à éviter !)
  nbsp = "␣",                   -- Espaces insécables
}

-- Remplissage des zones vides
vim.opt.fillchars = { eob = " " } -- Remplace les "~" après la fin du fichier par des espaces

-- Titre de la fenêtre
vim.opt.title = true            -- Change le titre de la fenêtre du terminal
vim.opt.titlestring = "%<%F%=%l/%L - nvim" -- Format: chemin/fichier  ligne/total - nvim

-- Mode et commandes
vim.opt.showmode = false        -- Cache "-- INSERT --" (la statusline le montre déjà)
vim.opt.showcmd = false         -- Cache les commandes partielles en bas à droite
vim.opt.ruler = false           -- Cache la position du curseur (ligne,col) en bas

-- Ligne de commande
vim.opt.cmdheight = 0           -- Hauteur de la ligne de commande (0 = caché, colle la statusline au bord comme LazyVim)
vim.opt.shortmess:append("Ic") -- Réduit les messages: I=pas d'intro, c=pas de "match x of y"

-- Statusline
vim.opt.laststatus = 3          -- Statusline globale (3 = une seule ligne pour toutes les fenêtres, 2 = une par fenêtre)

-- ============================================================================
-- INDENTATION ET FORMATAGE
-- ============================================================================

-- Configuration de base (2 espaces, convertis en espaces)
-- Exception C/C++ configurée dans autocmds.lua (TAB de 4 pour norme 42)
vim.opt.tabstop = 2             -- Une TAB = 2 espaces visuellement
vim.opt.shiftwidth = 2          -- Indentation automatique = 2 espaces
vim.opt.expandtab = true        -- Convertit les TAB en espaces
vim.opt.smartindent = true      -- Indentation intelligente (après {, if, etc.)
vim.opt.shiftround = true       -- Arrondit l'indentation au multiple de shiftwidth avec < et >

-- Formatage automatique
vim.opt.formatoptions = "jql"   -- j=join intelligent, q=formatage avec gq, l=pas de wrap auto en Insert

-- ============================================================================
-- RECHERCHE
-- ============================================================================

vim.opt.ignorecase = true       -- Ignore majuscules/minuscules lors de la recherche
vim.opt.smartcase = true        -- Sauf si la recherche contient une majuscule
vim.opt.hlsearch = true         -- Surligne tous les résultats de recherche
vim.opt.incsearch = true        -- Recherche incrémentale (affiche pendant la frappe)
vim.opt.inccommand = "nosplit"  -- Prévisualisation en temps réel des :s/substitutions

-- Historique de recherche
vim.opt.shada = "!,'0,<50,s10,h"  -- Sauvegarde ShaDa SANS l'historique de recherche (pas de /)
                                   -- ! = variables globales, '0 = pas de marks, <50 = lignes par registre
                                   -- s10 = taille max registre (KB), h = désactive hlsearch au démarrage

-- Recherche avec ripgrep (utilisé par Telescope)
vim.opt.grepprg = "rg --vimgrep"    -- Utilise ripgrep au lieu de grep classique
vim.opt.grepformat = "%f:%l:%c:%m"  -- Format de sortie de grep

-- ============================================================================
-- ÉDITION ET COMPORTEMENT
-- ============================================================================

-- Wrap (retour à la ligne)
vim.opt.wrap = false            -- Pas de retour à la ligne automatique
vim.opt.linebreak = true        -- Si wrap activé: coupe sur les mots entiers
vim.opt.breakindent = true      -- Si wrap activé: garde l'indentation
vim.opt.showbreak = "↪ "        -- Symbole pour les lignes wrappées

-- Défilement
vim.opt.scrolloff = 8           -- Garde toujours 8 lignes visibles au-dessus/dessous du curseur
vim.opt.sidescrolloff = 8       -- Pareil horizontalement
vim.opt.smoothscroll = true     -- Défilement fluide ligne par ligne (Neovim 0.10+)

-- Souris
vim.opt.mouse = "a"             -- Active la souris dans tous les modes

-- Clipboard
vim.opt.clipboard = "unnamedplus" -- Synchronise avec le presse-papier système

-- Backspace
vim.opt.backspace = { "indent", "eol", "start" } -- Backspace peut tout supprimer

-- Join
vim.opt.joinspaces = false      -- J (join) n'ajoute qu'un seul espace (pas deux après un point)

-- Confirmation
vim.opt.confirm = true          -- Demande confirmation au lieu d'erreur quand fichier non sauvegardé

-- ============================================================================
-- SPLITS (FENÊTRES)
-- ============================================================================

vim.opt.splitright = true       -- Nouveaux splits verticaux s'ouvrent à droite
vim.opt.splitbelow = true       -- Nouveaux splits horizontaux s'ouvrent en bas
vim.opt.splitkeep = "screen"    -- Garde le contenu visible lors des splits (Neovim 0.9+)

-- ============================================================================
-- FICHIERS ET SAUVEGARDE
-- ============================================================================

-- Désactive les fichiers temporaires (on utilise undofile à la place)
vim.opt.swapfile = false        -- Pas de fichiers .swp
vim.opt.backup = false          -- Pas de fichiers de backup ~
vim.opt.writebackup = false     -- Pas de backup temporaire pendant l'écriture

-- Historique d'annulation persistant
vim.opt.undofile = true         -- Sauvegarde l'historique entre les sessions
vim.opt.undolevels = 10000      -- Nombre d'annulations possibles
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo" -- Emplacement des fichiers d'historique

-- Sauvegarde automatique
vim.opt.autowrite = true        -- Sauvegarde auto lors de :next, :make, etc.

-- Répertoire de travail
vim.opt.autochdir = false       -- Ne change PAS automatiquement de répertoire (garde la racine du projet)

-- Encodage
vim.opt.fileencoding = "utf-8"  -- Encodage des fichiers
vim.opt.encoding = "utf-8"      -- Encodage interne de Neovim

-- ============================================================================
-- COMPLÉTION
-- ============================================================================

vim.opt.pumheight = 10          -- Hauteur maximale du menu de complétion (popup)
vim.opt.completeopt = "menu,menuone,noselect" -- Comportement: menu, afficher même si 1 seul, pas de sélection auto

-- ============================================================================
-- WILDMENU (COMPLÉTION EN LIGNE DE COMMANDE)
-- ============================================================================

vim.opt.wildmode = "longest:full,full" -- Complétion: complète au max, puis menu
vim.opt.wildignore = {          -- Fichiers à ignorer dans la complétion
  -- Compilation C/C++
  "*.o", "*.obj", "*.a", "*.so", "*.dylib", "*.exe",

  -- Python
  "*.pyc", "*.pyo", "__pycache__/*", "*.egg-info/*",

  -- JavaScript/TypeScript
  "node_modules/*", "*.min.js", "dist/*", "build/*",

  -- Fichiers temporaires
  "*.swp", "*.swo", "*.tmp", "*~",

  -- Contrôle de version
  ".git/*", ".svn/*", ".hg/*",

  -- IDE
  ".vscode/*", ".idea/*", "*.sublime-workspace",

  -- Système
  ".DS_Store", "Thumbs.db", "desktop.ini",

  -- Archives
  "*.zip", "*.tar.gz", "*.rar", "*.7z",
}

-- ============================================================================
-- PERFORMANCE
-- ============================================================================

vim.opt.updatetime = 250        -- Temps avant déclenchement des événements (ms) - LSP, diagnostics
vim.opt.timeoutlen = 400        -- Temps d'attente pour les combinaisons de touches (ms)
vim.opt.ttimeoutlen = 10        -- Temps d'attente pour les codes de touches système (Esc, flèches)
vim.opt.lazyredraw = false      -- Redessine l'écran pendant les macros (plus rassurant)

-- ============================================================================
-- SÉLECTION VISUELLE
-- ============================================================================

vim.opt.virtualedit = "block"   -- Permet au curseur d'aller dans le vide en mode Visual Block (Ctrl+V)

-- ============================================================================
-- FEATURES DÉSACTIVÉES
-- ============================================================================

vim.opt.spell = false           -- Correction orthographique désactivée (activer manuellement avec :set spell)
vim.opt.foldenable = false      -- Code folding désactivé (sera configuré avec Treesitter si besoin)

-- ============================================================================
-- SYNTAXE
-- ============================================================================

vim.cmd("syntax on")            -- Active la coloration syntaxique

-- ============================================================================
-- INITIALISATION
-- ============================================================================

-- Crée le dossier undo s'il n'existe pas
vim.fn.mkdir(vim.fn.stdpath("data") .. "/undo", "p")
