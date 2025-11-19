local M = {}

-- Petite fenêtre flottante avec les raccourcis
function M.open()
  local buf = vim.api.nvim_create_buf(false, true)

  local lines = {
    "       🌟 ZELOXX — SHORTCUTS 🌟",
    "",
    "📁 Navigation",
    "  e      : Toggle Neo-tree",
    "  f      : Find files (Telescope)",
    "  r      : Recent files",
    "",
    "👨‍💻 Buffers",
    "  <Tab>  : Next buffer",
    "  <S-Tab>: Previous buffer",
    "  q      : Quit this menu",
    "",
    "⚙️ Divers",
    "  c      : Edit config",
    "  l      : Lazy",
    "",
    "Press 'q' to close",
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = 50
  local height = #lines
  local col = (vim.o.columns - width) / 2
  local row = (vim.o.lines - height) / 2

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  })

  -- Fermer avec Q
  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf })
end

return M
