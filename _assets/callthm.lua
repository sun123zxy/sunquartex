local function starts_with(start, str)
  return str:sub(1, #start) == start
end

function callout_tuple(type, appearance, collapse, icon)
  appearance = appearance or "minimal"
  collapse = collapse or "false"
  icon = icon or "false"
  return {
    type = type,
    appearance = appearance,
    collapse = collapse,
    icon = icon
  }
end

local thmmap = {
    thm = callout_tuple("note"),
    lem = callout_tuple("note"),
    cor = callout_tuple("note"),
    prp = callout_tuple("note"),
    cnj = callout_tuple("note"),
    def = callout_tuple("note"),
    exm = callout_tuple("tip"),
    exr = callout_tuple("tip")
}

local pfmap = {
  proof = callout_tuple("note", "default", "true"),
  solution = nil,
  remark = nil
}

if quarto.doc.is_format("html") then
  function Div(el)
    for index, value in pairs(thmmap) do
      if starts_with(index, el.attr.identifier) then
        if value == nil then
          return el
        else
          return pandoc.Div(el,pandoc.Attr("", {"callout-"..value.type}, {appearance = value.appearance, collapse = value.collapse, icon = value.icon}))
        end
      end
    end
    
    for index, value in pairs(pfmap) do
      if pandoc.List.find(el.attr.classes, index) then
        if value == nil then
          return el
        else
          -- TODO: change the title of the callout
          return pandoc.Div(el,pandoc.Attr("", {"callout-"..value.type}, {appearance = value.appearance, collapse = value.collapse, icon = value.icon}))
        end
      end
    end

    return el
  end
end