"""Render the real TikZ example and check the shapes in a browser screenshot."""

import argparse
import functools
import http.server
from io import BytesIO
from pathlib import Path
import subprocess
import threading

from PIL import Image
from playwright.sync_api import sync_playwright


class QuietHandler(http.server.SimpleHTTPRequestHandler):
    def log_message(self, *args):
        pass


def fill_ratio(png, color):
    image = Image.open(BytesIO(png)).convert('RGB')
    mask = Image.new('1', image.size)
    data = image.tobytes()
    pixels = zip(data[0::3], data[1::3], data[2::3])
    if color == 'orange':
        matches = [r > 230 and 110 < g < 210 and b < 100 for r, g, b in pixels]
    else:
        matches = [r < 150 and g < 150 and b > 230 for r, g, b in pixels]
    mask.putdata(matches)
    bounds = mask.getbbox()
    assert bounds, f'No {color} shape was drawn'
    x0, y0, x1, y1 = bounds
    return sum(matches) / ((x1 - x0) * (y1 - y0))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--quarto', default='quarto')
    parser.add_argument('--chromium', help='Optional path to a Chromium executable')
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[2]
    subprocess.run(
        [args.quarto, 'render', 'examples/tikz.qmd', '--to', 'html', '--quiet'],
        cwd=root, check=True,
    )
    server = http.server.ThreadingHTTPServer(
        ('127.0.0.1', 0), functools.partial(QuietHandler, directory=str(root / '_output')),
    )
    threading.Thread(target=server.serve_forever, daemon=True).start()
    try:
        with sync_playwright() as playwright:
            browser = playwright.chromium.launch(executable_path=args.chromium)
            for width in [1280, 390]:
                page = browser.new_page(viewport={'width': width, 'height': 900})
                page.goto(
                    f'http://127.0.0.1:{server.server_port}/examples/tikz.html',
                    wait_until='networkidle',
                )
                square = fill_ratio(page.locator('#fig-square .tikz').screenshot(), 'blue')
                circle = fill_ratio(page.locator('#fig-circle .tikz').screenshot(), 'orange')
                assert square > 0.97, f'Square was clipped incorrectly: {square}'
                # A circle fills pi/4 of its bounding square; the original
                # shared-ID bug incorrectly fills the whole square instead.
                assert 0.73 < circle < 0.85, f'Circle became a different shape: {circle}'
                issues = page.evaluate('''() => {
                    const ids=[...document.querySelectorAll('.tikz [id]')].map(e=>e.id);
                    return {
                        duplicateIds:ids.filter((id,i)=>ids.indexOf(id)!==i),
                        brokenImages:[...document.images].filter(i=>!i.complete || !i.naturalWidth).length,
                        brokenRefs:[...document.querySelectorAll('a.quarto-xref')].filter(a=>{
                            const target=new URL(a.getAttribute('href'),location.href);
                            if(target.origin!==location.origin || target.pathname!==location.pathname) return false;
                            return target.hash && !document.getElementById(decodeURIComponent(target.hash.slice(1)));
                        }).length,
                        imageOverflow:[...document.querySelectorAll('.tikz img, .tikz svg')].some(i=>i.getBoundingClientRect().right>innerWidth+1)
                    };
                }''')
                assert not any(issues.values()), issues
                print(f'{width}px: square={square:.3f}, circle={circle:.3f}; references and images OK')
                page.close()
            browser.close()
    finally:
        server.shutdown()
        server.server_close()


if __name__ == '__main__':
    main()
