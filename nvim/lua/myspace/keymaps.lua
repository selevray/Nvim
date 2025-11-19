-- Keymap pour insérer le header 42
vim.keymap.set("n", "<C-M-h>", "<cmd>Stdheader<CR>", { desc = "Insert 42 header" })
-- Keymap pour 42-Cformat
vim.api.nvim_set_keymap('n', '<F2>', ':CFormat42<CR>', { noremap = true, silent = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "lua", "python", "javascript" },
  callback = function()
    vim.keymap.set("n", "<Tab><Tab>", ":Neotree toggle<CR>", { buffer = true })
  end,
})

-- toggle undotree
vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', { noremap=true, silent=true })
-- ouvrir undotree et focus
vim.keymap.set('n', '<leader>U', ':UndotreeToggle | UndotreeFocus<CR>', { noremap=true, silent=true })

