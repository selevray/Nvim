-- ============================================================================
-- LSP.LUA - Configuration LSP moderne pour Neovim 0.11+
-- ============================================================================
-- Description: Configuration simplifiée utilisant l'approche moderne de Neovim 0.11
-- Stack: Mason → mason-lspconfig → nvim-lspconfig (auto-setup)
-- ============================================================================

return {
  -- ============================================================================
  -- MASON - Gestionnaire d'installation pour LSP/DAP/Linters/Formatters
  -- ============================================================================
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- ============================================================================
  -- MASON-LSPCONFIG - Installation et configuration automatique des LSP
  -- ============================================================================
  -- Avec Neovim 0.11, mason-lspconfig + nvim-lspconfig font tout automatiquement !
  -- Plus besoin de setup_handlers ni de configurations manuelles
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
      -- Liste des LSP à installer automatiquement
      ensure_installed = {
        "lua_ls",       -- Lua
        "pyright",      -- Python
        "clangd",       -- C/C++
        "ts_ls",        -- TypeScript/JavaScript
        "html",         -- HTML
        "cssls",        -- CSS
        "jsonls",       -- JSON
        "bashls",       -- Bash
      },
      -- Installation automatique quand on ouvre un fichier
      automatic_installation = false, -- Désactivé pour gérer manuellement

      -- Configuration automatique avec nvim-cmp capabilities
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
          })
        end,

        -- Configuration spécifique pour clangd (C/C++)
        ["clangd"] = function()
          require("lspconfig").clangd.setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            cmd = {
              "clangd",
              "--header-insertion=never",  -- Évite l'auto-insertion d'includes
              "--query-driver=/usr/bin/gcc", -- Path vers gcc
            },
            filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
          })
        end,
      },
    },
  },

  -- ============================================================================
  -- NVIM-LSPCONFIG - Configurations LSP
  -- ============================================================================
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- ======================================================================
      -- INTERFACE UTILISATEUR DES DIAGNOSTICS
      -- ======================================================================

      -- Icônes pour les diagnostics
      local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      -- Configuration des diagnostics
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 4,
        },
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- ======================================================================
      -- KEYMAPS LSP
      -- ======================================================================
      -- Ces raccourcis sont activés automatiquement quand un LSP s'attache

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }

          -- Navigation
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
          vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
          vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))

          -- Documentation
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

          -- Actions
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
          -- Note: <leader>f est géré par conform.nvim, pas par le LSP

          -- Diagnostics
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostic" }))
          vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Diagnostic list" }))
        end,
      })

      -- ======================================================================
      -- HIGHLIGHT DU SYMBOLE SOUS LE CURSEUR
      -- ======================================================================
      -- Highlight automatique des occurrences du symbole sous le curseur
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspHighlight", {}),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = ev.buf,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = ev.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })
    end,
  },

  -- ============================================================================
  -- NVIM-CMP - Moteur d'autocomplétion
  -- ============================================================================
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Sources de complétion
      "hrsh7th/cmp-nvim-lsp",     -- LSP
      "hrsh7th/cmp-buffer",        -- Buffer
      "hrsh7th/cmp-path",          -- Paths fichiers
      "hrsh7th/cmp-cmdline",       -- Ligne de commande

      -- Snippets
      "L3MON4D3/LuaSnip",          -- Moteur de snippets
      "saadparwaiz1/cmp_luasnip",  -- Source snippets pour cmp
      "rafamadriz/friendly-snippets", -- Collection de snippets

      -- UI
      "onsails/lspkind.nvim",      -- Icônes pour les types
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- Charger les snippets friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        -- ====================================================================
        -- SNIPPET ENGINE
        -- ====================================================================
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        -- ====================================================================
        -- FENÊTRE DE COMPLÉTION
        -- ====================================================================
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        -- ====================================================================
        -- MAPPINGS
        -- ====================================================================
        mapping = cmp.mapping.preset.insert({
          -- Navigation
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),

          -- Scroll documentation
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          -- Complétion
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          -- Snippets navigation
          ["<C-l>"] = cmp.mapping(function()
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function()
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),
        }),

        -- ====================================================================
        -- SOURCES DE COMPLÉTION (ordre = priorité)
        -- ====================================================================
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),

        -- ====================================================================
        -- FORMATAGE DES ITEMS
        -- ====================================================================
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            before = function(entry, vim_item)
              return vim_item
            end,
          }),
        },

        -- ====================================================================
        -- COMPORTEMENT
        -- ====================================================================
        experimental = {
          ghost_text = true, -- Aperçu du texte complété
        },
      })

      -- ======================================================================
      -- COMPLÉTION POUR LA LIGNE DE COMMANDE
      -- ======================================================================

      -- `/` et `?` pour la recherche
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- `:` pour les commandes
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
}

-- ============================================================================
-- NOTES ET COMMANDES UTILES
-- ============================================================================
--
-- ⚡ Nouveauté Neovim 0.11+ :
--   Avec l'approche moderne, mason-lspconfig + nvim-lspconfig font tout
--   automatiquement ! Plus besoin de setup_handlers complexes.
--
-- Commandes Mason:
--   :Mason                 - Ouvrir l'interface Mason
--   :MasonUpdate           - Mettre à jour Mason
--   :MasonInstall <pkg>    - Installer un package
--   :MasonUninstall <pkg>  - Désinstaller un package
--
-- Commandes LSP:
--   :LspInfo               - Info sur les LSP attachés
--   :LspStart              - Démarrer un LSP
--   :LspStop               - Arrêter un LSP
--   :LspRestart            - Redémarrer un LSP
--
-- Diagnostics:
--   :checkhealth lsp       - Vérifier la santé de la config LSP
--
-- Keymaps principaux:
--   Navigation:
--     gd            - Go to definition
--     gD            - Go to declaration
--     gi            - Go to implementation
--     gr            - Show references
--     gt            - Go to type definition
--
--   Documentation:
--     K             - Hover documentation
--     <C-k>         - Signature help
--
--   Actions:
--     <leader>rn    - Rename
--     <leader>ca    - Code action
--     <leader>f     - Format
--
--   Diagnostics:
--     [d            - Previous diagnostic
--     ]d            - Next diagnostic
--     <leader>d     - Show diagnostic
--     <leader>q     - Diagnostic list
--
--   Autocomplétion:
--     <Tab>         - Item suivant
--     <S-Tab>       - Item précédent
--     <CR>          - Confirmer
--     <C-Space>     - Déclencher complétion
--     <C-e>         - Fermer
--
-- Pour ajouter un LSP:
--   1. Ajoutez le nom dans ensure_installed
--   2. Redémarrez Neovim ou :Lazy sync
--   3. Il sera auto-installé et configuré !
--
-- Liste des LSP disponibles:
--   https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
--
-- Pour des configurations LSP personnalisées:
--   Ajoutez-les dans opts.handlers de mason-lspconfig
--   Exemple:
--     handlers = {
--       function(server_name) ... end,  -- handler par défaut
--       ["lua_ls"] = function() ... end, -- config custom pour lua_ls
--     }
-- ============================================================================
