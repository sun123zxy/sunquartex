local function starts_with(start, str)
  return str:sub(1, #start) == start
end

local thmmap = {
    thm = "note",
    lem = "note",
    cor = "note",
    prp = "note",
    cnj = "note",
    def = "note",
    exm = "tip",
    exr = "tip"
}

function Div(el)
  for index, value in pairs(thmmap) do
    if starts_with(index, el.attr.identifier) then
      return pandoc.Div(el,pandoc.Attr("", {"callout-"..value}, {appearance = "minimal"}))
    end
  end
  return el
end