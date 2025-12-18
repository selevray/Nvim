-- ============================================================================
-- NVIM-DAP.LUA - Configuration minimaliste du debugger (2025)
-- ============================================================================
-- Stack moderne: mason-nvim-dap → nvim-dap → nvim-dap-ui
-- ============================================================================

return {
  -- ============================================================================
  -- NVIM-DAP - Debugger pour Neovim
  -- ============================================================================
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Mason bridge pour installer automatiquement les debuggers
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
          -- Debuggers à installer automatiquement
          ensure_installed = {
            "codelldb", -- C/C++/Rust (moderne, recommandé pour 2025)
          },
          -- Installation automatique si manquant
          automatic_installation = true,
          -- Handlers REQUIS (même vide) pour la config auto
          handlers = {},
        },
      },

      -- Interface UI pour le debugger
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {}, -- Configuration par défaut (suffit pour commencer)
      },
    },

    -- Lazy loading via keymaps
    keys = {
      -- ======================================================================
      -- NIVEAU 1 : Keymaps essentiels
      -- ======================================================================
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },

      -- ======================================================================
      -- NIVEAU 2 : Navigation step-by-step (style LazyVim)
      -- ======================================================================
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },

      -- ======================================================================
      -- BONUS : Touches F (style VSCode) - Mêmes actions, keymaps alternatifs
      -- ======================================================================
      { "<F5>", function() require("dap").continue() end, desc = "Continue (F5)" },
      { "<F10>", function() require("dap").step_over() end, desc = "Step Over (F10)" },
      { "<F11>", function() require("dap").step_into() end, desc = "Step Into (F11)" },
      { "<F12>", function() require("dap").step_out() end, desc = "Step Out (F12)" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint (F9)" },
    },

    init = function()
      -- ======================================================================
      -- ICÔNES DE BREAKPOINTS (définies AVANT lazy loading)
      -- ======================================================================
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticWarn" })
    end,

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- ======================================================================
      -- AUTO-OPEN/CLOSE UI
      -- ======================================================================
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
