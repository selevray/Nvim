return {

  ----------------------------------------------------
  -- Dashboard 
  ----------------------------------------------------
{
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("myspace.dashboard")
  end,
},

{
    "MoulatiMehdi/42norm.nvim",
    config = function()
        local norm = require("42norm")

        norm.setup({
            header_on_save = true,
            format_on_save = true,
            liner_on_change = true,
        })

        -- Press "F5" key to run the norminette
        vim.keymap.set("n", "<F5>", function()
            norm.check_norms()
        end, { desc = "Update 42norms diagnostics", noremap = true, silent = true })

        vim.keymap.set("n", "<C-f>", function()
            norm.format()
        end, { desc = "Format buffer on 42norms", noremap = true, silent = true })

        vim.keymap.set("n", "<F1>", function()
            norm.stdheader()
        end, { desc = "Insert 42header", noremap = true, silent = true })

        -- create your commands
        vim.api.nvim_create_user_command("Norminette", function()
            norm.check_norms()
        end, {})
        vim.api.nvim_create_user_command("Format", function()
            norm.format()
        end, {})
        vim.api.nvim_create_user_command("Stdheader", function()
            norm.stdheader()
        end, {})
    end,
},

{
  "mbbill/undotree",
  keys = {
    { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Open UndoTree" },
  },
},
  ----------------------------------------------------
  -- Theme Catppuccin
  ----------------------------------------------------
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({ flavour = "mocha" })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  ----------------------------------------------------
  -- File icons
  ----------------------------------------------------
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  ----------------------------------------------------
  -- Telescope
  ----------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  ----------------------------------------------------
  -- Treesitter
  ----------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  ----------------------------------------------------
  -- Lualine
  ----------------------------------------------------
{
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "catppuccin",
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},  -- 🔥 plus aucun composant
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }
    })
  end
},


  ----------------------------------------------------
  -- Neo-tree (explorateur)
  ----------------------------------------------------
{
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local icons = require("nvim-web-devicons")

    -- Applique les icons de manière native
    require("neo-tree").setup({
      default_component_configs = {
        icon = {
          folder_closed = "󰉋",
          folder_open = "󰝰",
          folder_empty = "󰉖",
          default = function(config, node)
            local ext = node.ext or ""
            local icon, hl = icons.get_icon(ext)
            return {
              text = icon or "󰈔",
              highlight = hl or "NeoTreeFileIcon",
            }
          end,
        },
      },
      filesystem = {
        filtered_items = { visible = true },
      },
    })
  end,
},
  ----------------------------------------------------
  -- AutoPairs
  ----------------------------------------------------
{
  "windwp/nvim-autopairs",
  config = true,
},

  ----------------------------------------------------
  -- Indent Blankline
  ----------------------------------------------------

{
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  config = function()
    require("ibl").setup({
      exclude = {
        filetypes = {
          "dashboard",   -- ton dashboard
          "neo-tree",    -- explorer
          "help",
          "lazy",
          "mason",
          "terminal",
          "nofile",
        },
      },
    })
  end,
},

  ----------------------------------------------------
  -- Treesitter-Context
  ----------------------------------------------------
{
  "nvim-treesitter/nvim-treesitter-context",
  config = function()
    require("treesitter-context").setup({})
  end,
},

{
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup()
  end,
},

vim.api.nvim_create_user_command("Shortcut", function()
  require("myspace.zlx_shortcuts").open()
end, {}),

}
