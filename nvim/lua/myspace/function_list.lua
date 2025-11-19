local M = {}

local ns = vim.api.nvim_create_namespace("function_list_ns")

local function is_code_buffer()
  local invalid_ft = {
    dashboard = true,
    ["neo-tree"] = true,
    help = true,
    lazy = true,
    mason = true,
    telescope = true,
    [""] = true,
  }
  return not invalid_ft[vim.bo.filetype]
end

local function get_all_functions(bufnr)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok or not parser then return {} end

  local tree = parser:parse()[1]
  if not tree then return {} end

  local root = tree:root()
  local funcs = {}

  local function scan(node)
    local type = node:type()

    if type == "function_definition"
      or type == "function_declaration"
      or type == "function_item"
      or type == "method_declaration"
    then
      local s, _, e = node:range()
      table.insert(funcs, {
        line = s,
        lines = (e - s),
      })
    end

    for i = 0, node:child_count() - 1 do
      scan(node:child(i))
    end
  end

  scan(root)
  return funcs
end

function M.update()
  local bufnr = vim.api.nvim_get_current_buf()
  if not is_code_buffer() then return end

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local funcs = get_all_functions(bufnr)
  local win_width = vim.api.nvim_win_get_width(0)

  for _, f in ipairs(funcs) do
    vim.api.nvim_buf_set_extmark(bufnr, ns, f.line, 0, {
      virt_text = { { "ƒ " .. f.lines .. " lines", "Function" } },
      virt_text_pos = "overlay",        -- obligé pour 'virt_text_win_col'
      virt_text_win_col = win_width - 15, -- évite *toute* collision
    })
  end
end

return M
