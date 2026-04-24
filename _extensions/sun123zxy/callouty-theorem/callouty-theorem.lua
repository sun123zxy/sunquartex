---- some internal ultilities of Quarto's Lua filter
---- can't be directly called, thus copied here

-- copied from quarto-cli/src/resources/filters/common/refs.lua
local refType = function (id)
  if not id then
    return nil
  end
  local match = string.match(id, "^(%a+)%-")
  if match then
    return pandoc.text.lower(match)
  else
    return nil
  end
end

-- copied from quarto-cli/src/resources/filters/customnodes/theorem.lua
local theorem_types = {
  thm = {
    env = "theorem",
    style = "plain",
    title = "Theorem"
  },
  lem = {
    env = "lemma",
    style = "plain",
    title = "Lemma"
  },
  cor = {
    env = "corollary",
    style = "plain",
    title = "Corollary",
  },
  prp = {
    env = "proposition",
    style = "plain",
    title = "Proposition",
  },
  cnj = {
    env = "conjecture",
    style = "plain",
    title = "Conjecture"
  },
  def = {
    env = "definition",
    style = "definition",
    title = "Definition",
  },
  exm = {
    env = "example",
    style = "definition",
    title = "Example",
  },
  exr  = {
    env = "exercise",
    style = "definition",
    title = "Exercise"
  },
  alg = {
    env = "algorithm",
    style = "plain",
    title = "Algorithm"
  }
}

-- copied from quarto-cli/src/resources/filters/customnodes/proof.lua
local proof_types = {
  proof =  {
    env = 'proof',
    title = 'Proof'
  },
  remark =  {
    env = 'remark',
    title = 'Remark'
  },
  solution = {
    env = 'solution',
    title = 'Solution'
  }
}

---- meta reading stuff

-- recursively iterates through the metadata, stringifying all pandoc.Str elements
local function stringify_meta(meta)
  if type(meta) == 'table' then
    -- check if is a table with only one pandoc.Str element
    if #meta == 1 and meta[1].t == 'Str' then
      return pandoc.utils.stringify(meta)
    end
    for k, v in pairs(meta) do
      meta[k] = stringify_meta(v)
    end
  end
  return meta
end

local callouty_meta = nil

-- reads the metadata
local function read_meta(meta)
  callouty_meta = stringify_meta(meta['callouty-theorem'])
end

---- main logic

local function spawn_callout_title(type_title, name)
  local my_name = pandoc.List({type_title})
  if name then
    my_name:insert(" (")
    my_name:extend(pandoc.utils.blocks_to_inlines(pandoc.Blocks(name)))
    my_name:insert(")")
  end
  return my_name
end

local function shallow_copy(tbl)
  local copy = {}
  for k, v in pairs(tbl) do
    copy[k] = v
  end
  return copy
end

local function parse_boolean_attr(value, field)
  if value == nil then
    return nil
  end
  if type(value) == "boolean" then
    return value
  end
  if type(value) == "string" then
    local lowered = pandoc.text.lower(value)
    if lowered == "true" then
      return true
    elseif lowered == "false" then
      return false
    end
  end
  quarto.log.warning("callouty-theorem: unrecognized " .. field .. " value '" .. pandoc.utils.stringify(value) .. "'; expected 'true' or 'false'")
  return nil
end

local function apply_div_callout_overrides(callout_tbl, source_attr)
  if not source_attr or not source_attr.attributes then
    return
  end

  local attrs = source_attr.attributes
  for _, key in ipairs({"type", "appearance"}) do
    if attrs[key] ~= nil then
      callout_tbl[key] = attrs[key]
    end
  end

  for _, key in ipairs({"collapse", "icon"}) do
    local parsed = parse_boolean_attr(attrs[key], key)
    if parsed ~= nil then
      callout_tbl[key] = parsed
    end
  end
end

local function calloutify(el, is_proof)
  local typ, my_types, theorem_ctor
  if is_proof then
    typ = el.type:lower()
    my_types = proof_types
    theorem_ctor = quarto.Proof
  else
    typ = refType(el.identifier)
    my_types = theorem_types
    theorem_ctor = quarto.Theorem
  end

  if not typ then
    return el
  end

  if not callouty_meta or not callouty_meta[typ] then -- metadata not given, return as is
    return el
  end

  local override_title = false
  local callout_tbl = {type = "note"}
  if type(callouty_meta[typ]) == "table" then
    override_title = callouty_meta[typ]["override-title"] or override_title
    if type(callouty_meta[typ]["callout"]) == "table" then
      callout_tbl = shallow_copy(callouty_meta[typ]["callout"])
    end
  end

  local source_attr = (el.div and el.div.attr) or el.attr
  if override_title and my_types[typ] then
    callout_tbl.title = spawn_callout_title(my_types[typ].title, el.name)
  end

  apply_div_callout_overrides(callout_tbl, source_attr)

  callout_tbl.content = theorem_ctor(el)
  return quarto.Callout(callout_tbl)
end

-- Run in two passes so we process metadata
-- and then process the divs
return {
  { Meta = read_meta },
  { Theorem = function(el) return calloutify(el, false) end,
    Proof = function(el) return calloutify(el, true) end
  }
}