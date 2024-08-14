-- modified from a Pandoc filter example

local system = require 'pandoc.system'

local tikz_doc_template = [[
\documentclass{standalone}
\usepackage{xeCJK}
\usepackage{xcolor}
\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{tikz}
\usepackage{tikz-cd}
\usepackage{quiver}
\begin{document}
\nopagecolor
%s
\end{document}
]]

local function tikz2image(src, filetype)
  local str = ""
  system.with_temporary_directory('tikz2image', function (tmpdir)
    system.with_working_directory(tmpdir, function()
      local f = io.open('tikz.tex', 'w')
      if f == nil then
        str = "failed to open extracted TeX file: tikz.tex"
        return nil
      end
      f:write(tikz_doc_template:format(src))
      f:close()
      os.execute('xelatex tikz.tex')
      os.execute('dvisvgm tikz.pdf --pdf --zoom=1.45')
      local g = io.open('tikz.svg', 'r')
      if g == nil then
        str = "failed to open converted SVG file: tikz.svg"
        return nil
      end
      str = g:read("a")
      g:close()
      return nil
    end)
    return nil
  end)
  return str
end

local function file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function CodeBlock(el)
  local type = el.classes[1]
  -- quarto.log.output(type)
  if type == "{tikz}" then
    if quarto.doc.is_format("pdf") or quarto.doc.is_format("beamer") then
      return pandoc.RawInline("latex", el.text)
    elseif quarto.doc.is_format("html") then
      local filetype = 'svg'
      -- local fbasename = pandoc.sha1(el.text) .. '.' .. filetype
      -- local fname = fbasename
      local svg = ""
      -- if not file_exists(fname) then
      svg = tikz2image(el.text, filetype)
      -- end
      return pandoc.Div(pandoc.RawInline("html", svg), pandoc.Attr("", {"tikz"}))
    else
      return el
    end
  end
end