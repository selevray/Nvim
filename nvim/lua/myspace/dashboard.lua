local db = require("dashboard")

db.setup({
  theme = "hyper",
  config = {

    header = {
      [[██████╗ ██╗   ██╗    ███████╗███████╗██╗      ██████╗ ██╗  ██╗██╗  ██╗]],
      [[██╔══██╗╚██╗ ██╔╝    ╚══███╔╝██╔════╝██║     ██╔═══██╗╚██╗██╔╝╚██╗██╔╝]],
      [[██████╔╝ ╚████╔╝       ███╔╝ █████╗  ██║     ██║   ██║ ╚███╔╝  ╚███╔╝ ]],
      [[██╔══██╗  ╚██╔╝       ███╔╝  ██╔══╝  ██║     ██║   ██║ ██╔██╗  ██╔██╗ ]],
      [[██████╔╝   ██║       ███████╗███████╗███████╗╚██████╔╝██╔╝ ██╗██╔╝ ██╗]],
      [[╚═════╝    ╚═╝       ╚══════╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝]],
      "",
      " ✨  Welcome to ZELOXX Nvim  ✨ ",
      "",
      "        📁  Find File              [f]        ",
      "",
      "        📁  Open Folder (Neo-Tree) [e]        ",
      "",
      "        📝  New File               [n]        ",
      "",
      "        🕘  Recent Files           [r]        ",
      "",
      -- "        🔍  Find Text              [g]        ",
      -- "",
      "         🧠  Shortcuts              [s]        ",
      "",
      "        ⚙️  Config                 [c]        ",
      "",
      "        💤  Lazy                   [l]        ",
      "",
      "",
      "        ❌  Quit                   [q]        ",
      "",
    },

    -- raccourcis fonctionnels
    shortcut = {
      { icon = "", desc = "", key = "f", action = "Telescope find_files" },
      { icon = "", desc = "", key = "e", action = ":Neotree toggle" },
      { icon = "", desc = "", key = "n", action = "enew" },
      { icon = "", desc = "", key = "r", action = "Telescope oldfiles" },
      -- { icon = "", desc = "", key = "g", action = "Telescope live_grep" },
      { icon = "", desc = "", key = "c", action = ":Neotree ~/.config/nvim/" },
      { icon = "", desc = "", key = "l", action = "Lazy" },
      { icon = "", desc = "", key = "q", action = "qa" },
      { icon = "", desc = "Shortcuts", key = "s", action = ":Shortcut" },
    },

    project = { enable = false },
    mru = { enable = false },

    footer = {
      "",
      "⚡ ZELOXX loaded with lazy.nvim ⚡",
    },
  },
})
