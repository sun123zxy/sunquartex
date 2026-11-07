function Pandoc(doc)
  -- Check for an existing LaTeX appendix command before moving any blocks.
  local has_latex_appendix = false
  doc:walk({
    RawBlock = function(el)
      if el.format == 'latex' and el.text:match('\\appendix%f[^%a]') then
        has_latex_appendix = true
      end
    end
  })

  -- Collect asides in document order, removing their .aside class.
  local asides = pandoc.Blocks({})
  doc = doc:walk({
    traverse = 'topdown',
    Div = function(el)
      if el.classes:includes('aside') then
        el.classes = el.classes:filter(function(class) return class ~= 'aside' end)
        asides:insert(el)
        return {}, false -- Remove this block; keep nested asides inside it.
      end
    end
  })

  -- Append them to the end of the document
  if #asides > 0 then
    if not has_latex_appendix then
      doc.blocks:insert(pandoc.RawBlock('latex', '\\appendix'))
    end
    doc.blocks:insert(pandoc.Header(2, 'Side notes', pandoc.Attr('', {'appendix'})))
    doc.blocks:extend(asides)
  end
  return doc
end
