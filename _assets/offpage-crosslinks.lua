--- Off-Page Cross-Links - Lua Filter
--- @module "offpage-crosslinks"
--- @license MIT
--- @copyright 2026 Mickaël Canouil
--- @author Mickaël Canouil
--- @version 0.1.0
--- @brief Rewrite cross-page links for non-HTML formats using site-url.
--- @description In non-HTML output formats, relative links to other pages
--- in a Quarto website or book project are broken. This filter rewrites
--- those links to absolute URLs using the project's site-url, so readers
--- can follow them to the live HTML site.

-- ============================================================================
-- MODULE-LEVEL VARIABLES
-- ============================================================================

--- @type string|nil The resolved site URL from project metadata
local site_url = nil

-- ============================================================================
-- HELPER FUNCTIONS (PRIVATE)
-- ============================================================================

--- Read site-url from QUARTO_EXECUTE_INFO project metadata.
--- Tries website.site-url first, then book.site-url.
--- Workaround for https://github.com/quarto-dev/quarto-cli/issues/13029
--- where project-level metadata (website/book) is not available in the
--- document Meta passed to Lua filters.
--- @return string|nil The site-url value, or nil if unavailable
local function get_site_url_from_execute_info()
  local path = os.getenv('QUARTO_EXECUTE_INFO')
  if not path then return nil end

  local file = io.open(path, 'r')
  if not file then return nil end

  local content = file:read('*a')
  file:close()

  if not content or content == '' then return nil end

  local ok, info = pcall(quarto.json.decode, content)
  if not ok or not info then return nil end

  local format_meta = info['format'] and info['format']['metadata']
  if not format_meta then return nil end

  if format_meta['website'] and format_meta['website']['site-url'] then
    return format_meta['website']['site-url']
  elseif format_meta['book'] and format_meta['book']['site-url'] then
    return format_meta['book']['site-url']
  end

  return nil
end

--- Read site-url from document metadata as a fallback.
--- Tries website.site-url, then book.site-url.
--- @param meta table The document metadata table
--- @return string|nil The site-url value, or nil if not found
local function get_site_url_from_meta(meta)
  local website = meta['website']
  if website and website['site-url'] then
    return pandoc.utils.stringify(website['site-url'])
  end

  local book = meta['book']
  if book and book['site-url'] then
    return pandoc.utils.stringify(book['site-url'])
  end

  return nil
end

--- Check whether a link target is a relative cross-page link.
--- Returns true for targets that point to .html or .qmd files
--- without an absolute URI scheme.
--- @param target string The link target URL
--- @return boolean True if the target is a relative page link
local function is_relative_page_link(target)
  if not target or target == '' then return false end
  if target:match('^#') then return false end
  if target:match('^%a[%a%d+%-%.]*:') then return false end
  if target:match('%.html[#?]') or target:match('%.html$') then return true end
  if target:match('%.qmd[#?]') or target:match('%.qmd$') then return true end
  return false
end

--- Rewrite a relative page link target to an absolute URL.
--- Normalises .qmd extensions to .html, strips leading ./, and
--- prepends the site-url.
--- @param target string The original relative link target
--- @param base_url string The site-url to prepend
--- @return string The rewritten absolute URL
local function rewrite_target(target, base_url)
  local rewritten = target:gsub('%.qmd([#?])', '.html%1'):gsub('%.qmd$', '.html')
  rewritten = rewritten:gsub('^%./', '')
  local separator = base_url:match('/$') and '' or '/'
  return base_url .. separator .. rewritten
end

-- ============================================================================
-- FILTER EXPORT
-- ============================================================================

return {
  {
    -- Resolve site-url from project metadata.
    -- Skips entirely for HTML formats where cross-page links already work.
    Meta = function(meta)
      if quarto.doc.is_format('html') then return nil end

      site_url = get_site_url_from_execute_info()
      if not site_url then
        site_url = get_site_url_from_meta(meta)
      end

      if not site_url then
        quarto.log.warning('offpage-crosslinks: site-url not found in project metadata.')
      end

      return nil
    end
  },
  {
    -- Rewrite relative cross-page links to absolute URLs.
    Link = function(el)
      if not site_url then return nil end
      if not is_relative_page_link(el.target) then return nil end

      el.target = rewrite_target(el.target, site_url)
      return el
    end
  }
}
