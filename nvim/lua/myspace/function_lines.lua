local M = {}

-- Analyse toutes les fonctions du buffer avec un TreeCursor (compatible partout)
local function get_all_functions()
  local ok, parser = pcall(vim.treesitter.get_parser, 0)
  if not ok or not parser then
    return {}
  end

  local tree = parser:parse()[1]
  if not tree then return {} end

  local root = tree:root()
  local cursor = root:walker()

  local funcs = {}

  -- Parcours complet de l'arbre
  local node = cursor:current()

  while node do
    local type = node:type()

    if type == "function_definition" or type == "function_declaration" then
      local start_line, _, end_line, _ = node:range()
      local text = vim.treesitter.get_node_text(node, 0)

      local name = text:match("(%w+)%s*%(") or "function"
      local lines = end_line - start_line - 2

      table.insert(funcs, string.format("%s(%d)", name, lines))
    end

    node = cursor:next()
  end

  return funcs
end

-- Affiche la liste de fonctions dans la winbar
function M.update()
  local ft = vim.bo.filetype
  local invalid = {
    ["neo-tree"] = true,
    ["dashboard"] = true,
    ["help"] = true,
    ["lazy"] = true,
    ["mason"] = true,
    [""] = true,
  }

  if invalid[ft] then
    vim.wo.winbar = ""
    return
  end

  local funcs = get_all_functions()
  if #funcs == 0 then
    vim.wo.winbar = ""
    return
  end

  vim.wo.winbar = "%=FUNCTIONS: " .. table.concat(funcs, "   ")
end

return M
