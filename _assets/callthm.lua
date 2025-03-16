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

local thm_settings = {
  enable_title = false,
  callout_tbl = {
    type = "note",
    appearance = "minimal",
    collapse = nil,
    icon = nil
  }
}
local pf_settings = {
  enable_title = true,
  callout_tbl = {
    type = "note",
    appearance = "default",
    collapse = true,
    icon = nil
  }
}
local rem_settings = {
  enable_title = true,
  callout_tbl = {
    type = "tip",
    appearance = "default",
    collapse = false,
    icon = nil
  }
}

local thmmap = {
  thm = thm_settings,
  lem = thm_settings,
  cor = thm_settings,
  prp = thm_settings,
  cnj = thm_settings,
  def = thm_settings,
  exm = thm_settings,
  exr = thm_settings,
}

local pfmap = {
  proof = pf_settings,
  solution = pf_settings,
  remark = rem_settings
}

local function spawn_callout_title(type_title, name)
  local my_name = pandoc.List({type_title})
  if name then
    my_name:insert(" (")
    my_name:extend(pandoc.utils.blocks_to_inlines(pandoc.Blocks(name)))
    my_name:insert(")")
  end
  return my_name
end

local function calloutify_theorem(el)
  local type = refType(el.identifier)
  if not thmmap[type] then -- settings not given, return as is
    return el
  end

  local settings = thmmap[type]
  local enable_title = settings.enable_title
  local callout_tbl = settings.callout_tbl

  if enable_title then
    callout_tbl.title = spawn_callout_title(theorem_types[type].title, el.name)
  end
      
  callout_tbl.content = quarto.Theorem(el)
  local callout = quarto.Callout(callout_tbl)
  return callout
end

local function calloutify_proof(el)
  local type = el.type:lower()
  if not pfmap[type] then -- settings not given, return as is
    return el
  end

  local settings = pfmap[type]
  local enable_title = settings.enable_title
  local callout_tbl = settings.callout_tbl

  if enable_title then
    callout_tbl.title = spawn_callout_title(proof_types[type].title, el.name)
  end

  callout_tbl.content = quarto.Proof(el)
  local callout = quarto.Callout(callout_tbl)
  return callout
end

if quarto.doc.is_format("html") then
  function Theorem(el)
    return calloutify_theorem(el)
  end
  function Proof(el)
    return calloutify_proof(el)
  end
end