---- some internal ultilities of Quarto's Lua filter
---- can't be directly called, thus copied here

-- copied from quarto-cli/src/resources/filters/common/refs.lua
local refType = function (id)
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

local function calloutify(el, is_proof)
  local typ, my_types, my_Theorem
  if is_proof then
    typ = el.type:lower()
    my_types = proof_types
    my_Theorem = quarto.Proof
  else
    typ = refType(el.identifier)
    my_types = theorem_types
    my_Theorem = quarto.Theorem
  end

  if not callouty_meta or not callouty_meta[typ] then -- metadata not given, return as is
    return el
  end

  local override_title = false
  local callout_tbl = {type = "note"}
  if type(callouty_meta[typ]) == "table" then
    override_title = callouty_meta[typ]["override-title"] or override_title
    if type(callouty_meta[typ]["callout"]) == "table" then
      callout_tbl = callouty_meta[typ]["callout"]
    end
  end

  if override_title then
    callout_tbl.title = spawn_callout_title(my_types[typ].title, el.name)
  end
  callout_tbl.content = my_Theorem(el)
  local callout = quarto.Callout(callout_tbl)
  return callout
end

-- Run in two passes so we process metadata
-- and then process the divs
return {
  { Meta = read_meta },
  { Theorem = function(el) return calloutify(el, false) end,
    Proof = function(el) return calloutify(el, true) end
  }
}