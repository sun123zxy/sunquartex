-- Next generation of callthm.lua. To be used in post-ast.
-- Currently disabled. Waiting for Quarto to support Theorems and Proofs creation in the Lua filter.

local function callout_tbl(type, appearance, collapse, icon)
  local appearance = appearance or "minimal"
  local collapse = collapse or nil
  local icon = icon or nil
  return {
    type = type,
    appearance = appearance,
    collapse = collapse,
    icon = icon
  }
end

local thmmap = {
  thm = callout_tbl("note"),
  lem = callout_tbl("note"),
  cor = callout_tbl("note"),
  prp = callout_tbl("note"),
  cnj = callout_tbl("note"),
  def = callout_tbl("note"),
  exm = callout_tbl("tip"),
  exr = callout_tbl("tip"),
  Proof = callout_tbl("note", "default", true),
  Solution = callout_tbl("note", "default", true),
  Remark = callout_tbl("tip", "default", true)
}

local function filter(el)
    local refType = function (id)
      local match = string.match(id, "^(%a+)%-")
      if match then
        return pandoc.text.lower(match)
      else
        return nil
      end
    end
    local type = el.type or refType(el.identifier)
    if thmmap[type] then
      local name = pandoc.List({type})
      if el.name then
        name:insert(" (")
        name:extend(pandoc.utils.blocks_to_inlines(pandoc.Blocks(el.name)))
        name:insert(")")
      end
      
      local tbl = thmmap[type]
      tbl.title = name
      tbl.content = el.div
      local cl = quarto.Callout(tbl)
      return cl
    end
end


if quarto.doc.is_format("html") then
  function Theorem(el)
    return filter(el)
  end
  function Proof(el)
    return filter(el)
  end
end