local function starts_with(start, str)
  return str:sub(1, #start) == start
end

local function callout_dict(type, appearance, collapse, icon)
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
  thm = callout_dict("note"),
  lem = callout_dict("note"),
  cor = callout_dict("note"),
  prp = callout_dict("note"),
  cnj = callout_dict("note"),
  def = callout_dict("note"),
  exm = callout_dict("tip"),
  exr = callout_dict("tip")
}

local pfmap = {
  proof = callout_dict("note", "default", "true"),
  solution = callout_dict("note", "default", "true"),
  remark = callout_dict("tip", "default", "false")
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
      if starts_with(index, el.attr.identifier) then
        if value == nil then
          return el
        end

        return pandoc.Div(el, pandoc.Attr("", {"callout-"..value.type}, {appearance = value.appearance, collapse = value.collapse, icon = value.icon}))
      end
    end
    
    for index, value in pairs(pfmap) do
      if pandoc.List.find(el.attr.classes, index) then
        
        if value == nil then
          return el
        end

        local title = fetch_header(el)
        
        if title ~= nil then
          title = index .. ": " .. title
        elseif value.collapse ~= "" then
          title = index
        end

        local classes = {appearance = value.appearance, collapse = value.collapse, icon = value.icon, title = title}
        return pandoc.Div(el, pandoc.Attr("", {"callout-"..value.type}, classes))
      end
    end

    return el
  end
end