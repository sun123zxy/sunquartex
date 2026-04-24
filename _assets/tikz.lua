-- modified from a Pandoc filter example

local system = require 'pandoc.system'
local processed_tikz_count = 0

-- if use dvi/xdv output
-- \documentclass[tikz,dvisvgm]{standalone}

local function read_file(file)
  local f = io.open(file, 'r')
  if not f then return nil end
  local content = f:read('a')
  f:close()
  return content
end

local tikz_doc_template = read_file(
  pandoc.path.join({ quarto.project.directory, '_assets', 'suntemp-tikz.tex' })
)

local function execute_command(command, log_file)
  local status = os.execute(command .. ' > ' .. log_file .. ' 2>&1')
  if status ~= true then
    local log = read_file(log_file)
    return false, command, log
  end
  return true
end

local function tikz2image(src, filetype)
  return system.with_temporary_directory('tikz2image', function (tmpdir)
    return system.with_working_directory(tmpdir, function()
      
      local f = io.open('mytikz.tex', 'w')
      if not f then error("failed to open extracted TeX file") end
      
      if not tikz_doc_template then
        error("Cannot find the template for tikz.")
      end
      f:write(tikz_doc_template:format(src))
      f:close()
      
      local result, command, log = execute_command('xelatex mytikz.tex', 'xelatex_output.log')
      if not result then
        print('Command failed: ' .. command)
        print(log)
        error("failed to compile TeX file to PDF. Logs printed above.")
      end

      result, command, log = execute_command('dvisvgm mytikz.pdf --pdf --zoom=1.5 --font-format=woff2 --no-styles', 'dvisvgm_output.log')
      if not result then
        print('Command failed: ' .. command)
        print(log)
        error("failed to convert PDF file to SVG. Logs printed above.")
      end
      
      local str = read_file('mytikz.svg')
      if not str then
        error("failed to open converted SVG file")
      end
      processed_tikz_count = processed_tikz_count + 1
      return str
    end)
  end)
end

local function code_block_filter(el)
  local type = el.classes[1]
  if type == "{tikz}" then
    if quarto.doc.is_format("pdf") or quarto.doc.is_format("beamer") then
      return pandoc.RawInline("latex", el.text)
    elseif quarto.doc.is_format("html") then
      local filetype = 'svg'
      local svg = tikz2image(el.text, filetype)
      return pandoc.Div(pandoc.RawInline("html", svg), pandoc.Attr("", {"tikz"}))
    else
      return el
    end
  end
end

local function pandoc_filter(doc)
  if processed_tikz_count > 0 then
    print('tikz: ' .. processed_tikz_count .. ' tikz images successfully processed.')
  end
  return doc
end

return {
  { CodeBlock = code_block_filter },
  { Pandoc = pandoc_filter }
}