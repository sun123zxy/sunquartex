-- wrap with aside if the div is not pure
function Div(el)
  if el.classes:includes('aside')
      and (#el.classes > 1 or el.identifier ~= '' or #el.attributes > 0) then
    el.classes = el.classes:filter(function(class) return class ~= 'aside' end)
    return pandoc.Div({el}, pandoc.Attr('', {'aside'}))
  end
end
