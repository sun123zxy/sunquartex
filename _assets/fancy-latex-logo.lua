-- Insert custom LaTeX commands into the document header
function Meta(meta)
  if FORMAT == 'html' then
    local header_includes = meta['header-includes']
    if not header_includes then
      header_includes = pandoc.List()
    elseif type(header_includes) ~= 'table' or not header_includes.t then
      header_includes = pandoc.List{header_includes}
    end
    header_includes:insert(pandoc.RawBlock('html',[[<script>
MathJax = {
  tex: {
    macros: {
        SunQuarTeX: String.raw`\mathrm{\mathbf S \;\!\! {\scriptstyle \mathbf U \;\!\! \mathbb N} \mathbb Q \;\!\! {\scriptstyle \mathbf U \;\!\! \;\!\! \mathbf A \;\!\! \mathbb R} \;\!\! \;\!\! \mathbf{\TeX}}`
    }
  }
};
</script>]]))
    meta['header-includes'] = header_includes
    quarto.log.output('LaTeX Fancified (-> ' .. FORMAT .. '): Added \\SunQuarTeX macro to header')
  elseif FORMAT == 'latex' or FORMAT == 'pdf' or FORMAT == 'beamer' then
    meta['sunquartex-logo'] = pandoc.RawBlock('tex', [[\newcommand{\SunQuarTeX}{\(\mathrm{\mathbf S \;\!\! {\scriptstyle \mathbf U \;\!\! \mathbb N} \mathbb Q \;\!\! {\scriptstyle \mathbf U \;\!\! \;\!\! \mathbf A \;\!\! \mathbb R} \;\!\! \;\!\! \textbf{\TeX}}\)}]])
    quarto.log.output('LaTeX Fancified (-> ' .. FORMAT .. '): Added \\SunQuarTeX macro to header')
  end
  
  return meta
end


-- In HTML output, use MathJax to render the LaTeX command. \mathrm mimics the text style.
-- In LaTeX / PDF / Beamer output, use the raw LaTeX command
-- In other outputs, just use the plain text
function default_config(command)
  return {
    html = pandoc.Math('InlineMath', '\\mathrm{\\' .. command .. '}'),
    latex = pandoc.RawInline('tex', '\\' .. command .. '{}'),
    pdf = pandoc.RawInline('tex', '\\' .. command .. '{}'),
    beamer = pandoc.RawInline('tex', '\\'..command .. '{}'),
    others = pandoc.Str(command)
  }
end

-- Define your list of words and their corresponding TeX commands here
-- use 1 to indicate keeping the original

local config = {
  ["\\TeX"] = default_config("TeX"),
  ["\\LaTeX"] = default_config("LaTeX"),
  ["\\SunQuarTeX"] = default_config("SunQuarTeX"),
}

function Pandoc(doc)
  return doc
end

function RawInline(el)
  
  local leading = el.text:match("^(%s*)")
  local trailing = el.text:match("(%s*)$")
  local text = el.text:match("^%s*(.-)%s*$")
  local replacement = config[text]
  if not replacement then return nil end
  
  local s = replacement[FORMAT]
  if s == 1 then return nil end  -- keep original
  if not s then s = replacement["others"] end
  if not s then return nil end

  output = pandoc.List()
  
  if leading ~= "" then output:insert(pandoc.Space()) end
  output:insert(s)
  if trailing ~= "" then output:insert(pandoc.Space()) end
  
  quarto.log.output('LaTeX Fancified (-> ' .. FORMAT .. '): ')
  quarto.log.output('  ' .. tostring(el) .. ' -> ' .. tostring(output))

  return output
end