-- ============================================================================
-- AUTOCMDS.LUA - Automatisations Neovim
-- ============================================================================
-- Description: Commandes automatiques pour adapter le comportement selon le contexte
-- ============================================================================

-- ============================================================================
-- INDENTATION PAR TYPE DE FICHIER
-- ============================================================================

-- Groupe d'autocommands pour l'indentation (évite les doublons lors du rechargement)
local indent_group = vim.api.nvim_create_augroup("FileTypeIndent", { clear = true })

-- C et C++ : Norme 42 (TAB de 4 espaces, pas de conversion en espaces)
vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.tabstop = 4        -- Une TAB affiche 4 espaces
    vim.opt_local.shiftwidth = 4     -- Indentation de 4
    vim.opt_local.expandtab = false  -- Garde les vraies TAB (pas d'espaces)
  end,
  desc = "Indentation C/C++ (Norme 42: TAB de 4)",
})

-- Python : PEP8 (4 espaces, pas de TAB)
vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true   -- Convertit TAB en espaces
  end,
  desc = "Indentation Python (PEP8: 4 espaces)",
})

-- Makefiles : TAB obligatoires (syntaxe Make)
vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = "make",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false  -- Les Makefiles DOIVENT utiliser des TAB
  end,
  desc = "Indentation Makefile (TAB obligatoires)",
})

-- JavaScript/TypeScript : 2 espaces (standard moderne)
vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
  desc = "Indentation JS/TS (2 espaces)",
})

-- ============================================================================
-- HIGHLIGHT LORS DU YANK (COPIE)
-- ============================================================================

-- Flash visuel quand tu copies du texte (très utile pour voir ce qui a été copié)
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = highlight_group,
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",  -- Groupe de highlight (même couleur que la recherche)
      timeout = 200,          -- Durée du flash en ms
    })
  end,
  desc = "Flash visuel lors du yank (copie)",
})

-- ============================================================================
-- RETOUR À LA DERNIÈRE POSITION
-- ============================================================================

-- Quand tu réouvres un fichier, retourne à la dernière position du curseur
local cursor_group = vim.api.nvim_create_augroup("RestoreCursor", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
  group = cursor_group,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Retourne à la dernière position du curseur",
})

-- ============================================================================
-- NETTOYAGE AUTOMATIQUE
-- ============================================================================

-- Groupe pour le nettoyage
local cleanup_group = vim.api.nvim_create_augroup("AutoCleanup", { clear = true })

-- Supprime les trailing spaces (espaces en fin de ligne) avant la sauvegarde
-- Important pour la norme 42 !
vim.api.nvim_create_autocmd("BufWritePre", {
  group = cleanup_group,
  pattern = "*",
  callback = function()
    -- Sauvegarde la position du curseur
    local save_cursor = vim.fn.getpos(".")
    -- Supprime les trailing spaces
    vim.cmd([[%s/\s\+$//e]])
    -- Restaure la position du curseur
    vim.fn.setpos(".", save_cursor)
  end,
  desc = "Supprime les trailing spaces avant sauvegarde",
})

-- Ajoute une ligne vide à la fin du fichier si elle n'existe pas (bonne pratique POSIX)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = cleanup_group,
  pattern = "*",
  callback = function()
    local n_lines = vim.api.nvim_buf_line_count(0)
    local last_nonblank = vim.fn.prevnonblank(n_lines)
    if last_nonblank <= n_lines then
      vim.api.nvim_buf_set_lines(0, last_nonblank, n_lines, true, { "" })
    end
  end,
  desc = "Assure une ligne vide à la fin du fichier",
})

-- ============================================================================
-- BUFFERS SPÉCIAUX
-- ============================================================================

-- Groupe pour les buffers spéciaux (help, quickfix, etc.)
local special_buffers = vim.api.nvim_create_augroup("SpecialBuffers", { clear = true })

-- Ferme certains buffers spéciaux avec 'q'
vim.api.nvim_create_autocmd("FileType", {
  group = special_buffers,
  pattern = {
    "help",
    "qf",           -- Quickfix
    "lspinfo",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "Ferme les buffers spéciaux avec 'q'",
})

-- Désactive les numéros de ligne dans les buffers terminaux
vim.api.nvim_create_autocmd("TermOpen", {
  group = special_buffers,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
  desc = "Désactive les numéros dans les terminaux",
})

-- ============================================================================
-- REDIMENSIONNEMENT AUTOMATIQUE DES SPLITS
-- ============================================================================

-- Quand tu redimensionnes la fenêtre Neovim, ajuste automatiquement les splits
local resize_group = vim.api.nvim_create_augroup("ResizeSplits", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
  group = resize_group,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
  desc = "Redimensionne les splits automatiquement",
})

-- ============================================================================
-- DÉTECTION DE FICHIERS 42
-- ============================================================================

-- Détecte automatiquement les headers 42 et active des options spécifiques
local ft42_group = vim.api.nvim_create_augroup("42FileType", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = ft42_group,
  pattern = "*.h",
  callback = function()
    -- Vérifie si c'est un header 42 (contient le header standard)
    local first_lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
    for _, line in ipairs(first_lines) do
      if line:match("42") or line:match("student.42") then
        -- Active des options spécifiques si nécessaire
        -- Par exemple, détection automatique de la norme
        break
      end
    end
  end,
  desc = "Détection des fichiers 42",
})

-- ============================================================================
-- NOTES
-- ============================================================================

--[[
  Autres autocmds utiles que tu peux ajouter plus tard :

  - Auto-save : Sauvegarde automatique en quittant le mode Insert
  - Format on save : Formatage automatique avec un formatter (prettier, clang-format)
  - LSP attach : Configuration spécifique quand LSP s'attache à un buffer
  - Git signs : Refresh automatique des signes Git
  - Spell check : Active la correction orthographique pour markdown/txt

  Ces autocmds seront probablement gérés par des plugins (conform.nvim, LSP, etc.)
--]]
