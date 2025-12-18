-- ============================================================================
-- CONFORM.LUA - Configuration minimaliste du formatage de code
-- ============================================================================
-- Plugin: https://github.com/stevearc/conform.nvim
-- ============================================================================

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      -- Formatters par type de fichier
      formatters_by_ft = {
        -- Lua
        lua = { "stylua" },

        -- Python (vous pouvez en choisir un ou les chaîner)
        python = { "isort", "black" }, -- isort trie les imports, puis black formate

        -- JavaScript/TypeScript/React/Vue
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },

        -- Web (HTML/CSS/JSON/YAML)
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },

        -- C/C++ (42 School)
        c = { "c_formatter_42" },
        cpp = { "clang_format" },

        -- Shell/Bash
        sh = { "shfmt" },
        bash = { "shfmt" },

        -- Go
        go = { "gofmt", "goimports" },

        -- Rust (rustfmt est généralement installé avec Rust)
        rust = { "rustfmt" },

        -- Autres
        toml = { "taplo" },

        -- Fallback: utilise LSP si pas de formatter défini
        ["_"] = { "trim_whitespace" }, -- Enlève les espaces en fin de ligne
      },

      -- Format automatique à la sauvegarde (désactivé par défaut)
      format_on_save = nil,

      -- Configuration des formatters personnalisés
      formatters = {
        c_formatter_42 = {
          command = "c_formatter_42",
          stdin = true,
        },
      },
    },
  },

  -- Installation automatique des formatters
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "stylua",    -- Lua
        "black",     -- Python
        "prettier",  -- JS/TS/JSON/Markdown
      },
    },
  },
}
