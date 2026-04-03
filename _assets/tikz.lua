function CodeBlock(el)
  local type = el.classes[1]
  if type == "{tikz}" then
    if quarto.doc.is_format("pdf") or quarto.doc.is_format("beamer") then
      return pandoc.RawInline("latex", el.text)
    elseif quarto.doc.is_format("html") then
      local filetype = 'svg'
      local wrapped = '<script type="text/tikz">' .. el.text .. '</script>'
      return pandoc.RawInline("html", wrapped)
    else
      return el
    end
  end
end