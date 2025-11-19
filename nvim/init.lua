-- ===================================
-- Lazy.nvim bootstrap
-- ===================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- ===================================
-- Load plugins
-- ===================================
require("lazy").setup("plugins")

-- ===================================
-- Basic options
-- ===================================
vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.api.nvim_create_autocmd(
  { "BufEnter", "BufWritePost", "TextChanged", "CursorMoved" },
  {
    callback = function()
      require("myspace.function_list").update()
    end,
  }
)

-- Supprime les fichiers .swp obsolètes automatiquement
vim.api.nvim_create_autocmd("SwapExists", {
  callback = function()
    local fname = vim.v.swapname
    if fname and vim.fn.filereadable(fname) == 1 then
      vim.cmd("silent! swapname delete")
      vim.cmd("let v:swapchoice = 'e'")
    else
      vim.cmd("let v:swapchoice = 'o'")
    end
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    require("myspace.function_list").update()
  end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "WinResized" }, {
  callback = function()
    require("myspace.function_list").update()
  end,
})



