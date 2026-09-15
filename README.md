# tvtroid.github.io

Marketing site for TvTroid's mobile apps. Plain HTML/CSS/JS, in 10 languages.

The language pages are **generated** — edit `site/content.py`, never the HTML directly,
or your change will be overwritten on the next build.

## Editing

```sh
python3 site/build.py     # regenerates index.html, <lang>/index.html, sitemap.xml
```

- **Copy changes** → `STRINGS` in `site/content.py` (one block per language).
- **Adding an app** → append to `APPS` in `site/content.py`, then add a `desc`/`tagline`
  under each language's `apps` dict. Put the icon in `images/`.
- **Adding a language** → add it to `LANGS` and add a matching `STRINGS` block.
- **Design/layout** → `assets/main.css`, or the page template in `site/build.py`.

`privacy-policy.html` and `404.html` are hand-written and English-only.

## Local preview

```sh
python3 -m http.server 4321
```

Then open http://localhost:4321

## Deploying

Push to `main`. GitHub Pages serves the files as-is (`.nojekyll` disables Jekyll).
Commit the generated HTML — it is what actually gets served.

## How language selection works

- English lives at `/`, others at `/vi/`, `/ja/`, … each a real crawlable page
  with `hreflang` tags.
- First visit auto-redirects to the browser's language if it's one of the 10.
- An explicit pick is saved to `localStorage` and wins from then on.
- Deep links (anything with a `?query` or `#hash`) are never auto-redirected.

The per-app landing pages detect language on their own via `navigator.language`,
so they can't be forced into a language by URL.
