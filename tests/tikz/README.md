# Multiple TikZ figures

The square and circle in `examples/tikz.qmd` deliberately generate the same SVG
clipping-path ID. With the original inline SVG renderer, the second figure uses
the first figure's clipping path: the orange circle becomes a square in HTML.

Run the browser check from the repository root after installing the TikZ tools
listed in the main README (`xelatex`, `dvisvgm`, and `mutool` on `PATH`):

```sh
uv run --with playwright --with pillow playwright install chromium
uv run --with playwright --with pillow python tests/tikz/check.py
```

Use `--quarto /path/to/quarto` and `--chromium /path/to/chromium` for existing
installations. The check renders the real example, captures each colored shape
in the page, and measures its filled area relative to its bounding square. A
circle should occupy roughly `pi/4` of that square; the shared-ID regression
occupies all of it. Both desktop and mobile widths are checked, along with
duplicate IDs, image loading, and figure references.

This is a manual check; it adds no CI trigger or project runtime dependency.
