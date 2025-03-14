local function starts_with(start, str)
  return str:sub(1, #start) == start
end

local function callout_tbl(type, appearance, collapse, icon)
  local appearance = appearance or "minimal"
  local collapse = collapse or ""
  local icon = icon or ""
  return {
    type = type,
    appearance = appearance,
    collapse = collapse,
    icon = icon
  }
end

local thmmap = {
  thm = {"Theorem", callout_tbl("note")},
  lem = {"Lemma", callout_tbl("note")},
  cor = {"Corollary", callout_tbl("note")},
  prp = {"Proposition", callout_tbl("note")},
  cnj = {"Conjecture", callout_tbl("note")},
  def = {"Definition", callout_tbl("note")},
  exm = {"Example", callout_tbl("tip")},
  exr = {"Exercise", callout_tbl("tip")},
  proof = {"Proof", callout_tbl("note", "default", "true")},
  solution = {"Solution", callout_tbl("note", "default", "true")},
  remark = {"Remark", callout_tbl("tip", "default", "false")}
}

local function fetch_header(el)
  if el.content == nil then
    return nil
  end
  if el.content[1].t == "Header" and el.content[1].level == 2 then
    return pandoc.utils.stringify(el.content[1])
  else 
    return nil
  end
end

if quarto.doc.is_format("html") then
  function Div(el)
    for index, value in pairs(thmmap) do
      local fullname = value[1]
      local tbl = value[2]
      if pandoc.List.find(el.attr.classes, index) or starts_with(index, el.attr.identifier) then
        
        if tbl == nil then
          return el
        end

        local title = nil
        if tbl.appearance ~= "minimal" then
          title = fetch_header(el)
          if title ~= nil then
            title = fullname .. " (" .. title .. ")"
          else
            title = fullname
          end
        end
        local classes = {appearance = tbl.appearance, collapse = tbl.collapse, icon = tbl.icon, title = title}
        return pandoc.Div(el, pandoc.Attr("", {"callout-"..tbl.type}, classes))
      end
    end

    return el
  end
end