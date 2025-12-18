-- ============================================================================
-- COLORSCHEME.LUA - Thème de couleurs Dracula
-- ============================================================================
-- Description: Thème Dracula officiel pour Neovim
-- Plugin: Mofiqul/dracula.nvim
-- ============================================================================

return {
  -- ============================================================================
  -- DRACULA - Thème de couleurs
  -- ============================================================================
  {
    "Mofiqul/dracula.nvim",
    lazy = false,     -- Charge immédiatement (important pour un thème)
    priority = 1000,  -- Charge AVANT tous les autres plugins (évite les flashs)

    config = function()
      -- ========================================================================
      -- CONFIGURATION DRACULA
      -- ========================================================================
      require("dracula").setup({
        -- Transparence du background
        transparent_bg = false,  -- false = fond opaque (plus lisible)

        -- Commentaires en italique (plus stylé)
        italic_comment = true,

        -- Overrides pour garder la cohérence avec les plugins
        overrides = {
          -- Dashboard BIZZON (garde les couleurs définies)
          DashboardHeader = { fg = "#BD93F9", bold = true },  -- Violet
          DashboardFooter = { fg = "#50FA7B" },               -- Vert
          DashboardShortCut = { fg = "#FF79C6", bold = true }, -- Rose
          DashboardIcon = { fg = "#8BE9FD" },                 -- Cyan

          -- Telescope (garde les couleurs définies)
          TelescopeBorder = { fg = "#BD93F9" },
          TelescopePromptBorder = { fg = "#BD93F9" },
          TelescopeResultsBorder = { fg = "#BD93F9" },
          TelescopePreviewBorder = { fg = "#BD93F9" },
        },
      })

      -- ========================================================================
      -- ACTIVATION DU THÈME
      -- ========================================================================
      vim.cmd("colorscheme dracula")
    end,
  },
}
