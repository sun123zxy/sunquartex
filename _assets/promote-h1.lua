local flag = false
function Pandoc (doc)
  doc.blocks = doc.blocks:walk {
    Header = function (h)
      if h.level == 1 and not flag then -- promote the first H1, even there are already a metadata title
        doc.meta.title = h.content
        quarto.log.output("Promoted H1 to title: " .. pandoc.utils.stringify(h.content))
        flag = true
        return {}  -- remove this heading from the body
      end
    end
  }
  return doc
end
