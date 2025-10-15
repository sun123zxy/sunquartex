-- Modified from https://github.com/gleachkr/lean.lua
-- and https://github.com/mcanouil/quarto-external/

local lpeg = require("lpeg")

local nonwhitespace = (1 - lpeg.S("\n\r\t ")) ^ 0

local commentstart = lpeg.P([[/-]])

local commentend = lpeg.P([[-/]])

function HandleComment(prefix, raw)
    return table.unpack(quarto.utils.string_to_blocks(raw))
end

function HandleCode(raw)
    if raw:find("^[%s%c]+$") then return -1 end
    
    -- If the block ends with "-/\n" or -/  \n", we strip that whitespace
    --
    -- Whitespace is otherwise preserved
    --
    raw = raw:match("^[ \t]*\n(.*)$") or raw
    
    -- Strip leading and trailing empty lines (including lines with only spaces/tabs)
    raw = raw:gsub("^[ \t]*\n", ""):gsub("\n[ \t]*$", "")
    
    return pandoc.CodeBlock(raw, {class = "lean"})

end

local theGrammar = {
    "output",
    output = lpeg.Ct((lpeg.V "block" + lpeg.V "comment") ^ 0),
    comment = commentstart * lpeg.C(nonwhitespace) * lpeg.C((1 - commentend) ^ 1) * commentend / HandleComment,
    block = lpeg.C((1 - commentstart) ^ 1) / HandleCode
}

local G = lpeg.P(theGrammar)

return {
  ['lean-include'] = function (args, kwargs, meta, raw_args, context)
    local url = pandoc.utils.stringify(args[1])
    
    local mt, contents = pandoc.mediabag.fetch(url)
    if not contents then
      quarto.log.error("Could not open file '" .. url .. "'. Please check the URL or path.")
      return pandoc.Null()
    end

    local lst = pandoc.Blocks({})
    for i, v in ipairs(lpeg.match(G, contents)) do
      if v ~= -1 then
        lst:insert(v)
      end
    end
    return lst
  end
}