-- Work around https://github.com/quarto-dev/quarto-cli/issues/12584.
-- Run at post-quarto, before Quarto converts theorem/proof titles to LaTeX.
local function protect_title(el)
  if not quarto.doc.is_format('latex') or not el.name then
    return
  end

  local name = quarto.utils.as_inlines(el.name)
  if #name == 0 then
    return
  end

  -- Without this filter, Quarto produces titles such as:
  --   \begin{theorem}[Title \autocite[sec. 1]{key}]
  -- TeX mistakes the citation's closing ] for the end of the theorem title.
  -- Braces hide that inner ] while TeX reads the outer [...] argument:
  --   \begin{theorem}[{Title \autocite[sec. 1]{key}}]
  --
  -- Proofs need two pairs of braces: [{{Title ...}}]. The amsthm proof
  -- environment reads the title, removing its outer brace pair, then uses
  -- it again inside \item[...]. The remaining pair protects this second use.
  -- We apply this to all Quarto Proof nodes (including remarks/solutions).
  --
  -- Only add braces around the title; leave its text and citations intact
  -- so Pandoc can still format them normally.
  local braces = el.t == 'Proof' and '{{' or '{'
  local closing = el.t == 'Proof' and '}}' or '}'
  name:insert(1, pandoc.RawInline('latex', braces))
  name:insert(pandoc.RawInline('latex', closing))
  el.name = name
  return el
end

return {
  Theorem = protect_title,
  Proof = protect_title
}
