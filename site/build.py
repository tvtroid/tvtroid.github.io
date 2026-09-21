#!/usr/bin/env python3
"""Generate index.html plus one page per language from site/content.py.

    python3 site/build.py

English -> /index.html, others -> /<lang>/index.html
"""
import os
import re
import shutil
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from content import LANGS, APPS, STRINGS  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SITE_URL = "https://tvtroid.github.io"


def esc(s):
    return (str(s).replace("&", "&amp;").replace("<", "&lt;")
            .replace(">", "&gt;").replace('"', "&quot;"))


def star_svg():
    return ('<svg width="14" height="14" viewBox="0 0 20 20" fill="currentColor">'
            '<path d="M10 1.5l2.6 5.6 6.1.7-4.5 4.2 1.2 6-5.4-3-5.4 3 1.2-6-4.5-4.2 6.1-.7L10 1.5z"/></svg>')


def rel(path, lang):
    """Path from a page in `lang` back to a root-level asset."""
    return path if lang == "en" else "../" + path


def app_card(app, t, lang):
    cls = "app-card app-card--featured" if app["featured"] else "app-card"
    a = t["apps"][app["slug"]]
    name = esc(app["name"])

    badge = ""
    if app.get("badge"):
        badge = f'            <span class="app-card__badge">{esc(t[app["badge"]])}</span>\n'

    if app.get("rating"):
        meta = (f'              <span class="app-card__meta-item">{star_svg()}\n'
                f'                {esc(app["rating"])}\n'
                f'              </span>\n'
                f'              <span class="app-card__meta-item">{esc(app["installs"])} {esc(t["installs_suffix"])}</span>\n')
    else:
        meta = "".join(
            f'              <span class="app-card__meta-item">{esc(m)}</span>\n'
            for m in a.get("meta", [])
        )

    ios_badge = ""
    if app.get("ios"):
        ios_badge = (f'            <a href="{esc(app["ios"])}" class="store-badge" target="_blank" rel="noopener" aria-label="{name} — App Store">\n'
                     f'              <img src="{rel("images/appstore-badge.png", lang)}" alt="Download on the App Store" loading="lazy">\n'
                     f'            </a>\n')

    # Whole card links to the app's own landing page; store badges keep their
    # own links and stop the click from bubbling up to the card.
    return f"""        <article class="{cls} reveal" style="--accent: {app['accent']};">
          <a class="app-card__link" href="{esc(app['site'])}" target="_blank" rel="noopener"
             aria-label="{name}">
            <div class="app-card__icon-wrap">
              <img src="{rel(app['icon'], lang)}" alt="{name}" class="app-card__icon" loading="lazy">
            </div>
            <div class="app-card__body">
{badge}              <h3 class="app-card__title">{name}</h3>
              <p class="app-card__tagline">{esc(a['tagline'])}</p>
              <p class="app-card__description">{esc(a['desc'])}</p>
              <div class="app-card__meta">
{meta}              </div>
            </div>
          </a>
          <div class="app-card__actions">
            <a href="{esc(app['android'])}" class="store-badge" target="_blank" rel="noopener" aria-label="{name} — Google Play">
              <img src="{rel('images/google-play-badge.png', lang)}" alt="Get it on Google Play" loading="lazy">
            </a>
{ios_badge}          </div>
        </article>
"""


def lang_switcher(cur):
    opts = "".join(
        f'        <option value="{code}"{" selected" if code == cur else ""}>{esc(label)}</option>\n'
        for code, label, _ in LANGS
    )
    label = esc(STRINGS[cur]["lang_label"])
    return f"""      <div class="lang-switch">
        <svg class="lang-switch__icon" width="16" height="16" viewBox="0 0 20 20" fill="none" aria-hidden="true">
          <circle cx="10" cy="10" r="7.6" stroke="currentColor" stroke-width="1.5"/>
          <path d="M2.4 10h15.2M10 2.4c2 2.2 3 4.9 3 7.6s-1 5.4-3 7.6c-2-2.2-3-4.9-3-7.6s1-5.4 3-7.6z"
                stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/>
        </svg>
        <select class="lang-switch__select" aria-label="{label}" onchange="TvTroidLang.go(this.value)">
{opts}        </select>
      </div>
"""


def hreflangs(page_lang):
    out = []
    for code, _, bcp in LANGS:
        href = SITE_URL + ("/" if code == "en" else f"/{code}/")
        out.append(f'  <link rel="alternate" hreflang="{bcp}" href="{href}">')
    out.append(f'  <link rel="alternate" hreflang="x-default" href="{SITE_URL}/">')
    return "\n".join(out)


def build_page(lang, bcp):
    t = STRINGS[lang]
    cards = "\n".join(app_card(a, t, lang) for a in APPS)
    canonical = SITE_URL + ("/" if lang == "en" else f"/{lang}/")

    return f"""<!DOCTYPE html>
<html lang="{bcp}">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="theme-color" content="#0b0f19">
  <title>{esc(t['page_title'])}</title>
  <meta name="description" content="{esc(t['meta_desc'])}">
  <link rel="canonical" href="{canonical}">
{hreflangs(lang)}

  <meta property="og:title" content="{esc(t['page_title'])}">
  <meta property="og:description" content="{esc(t['meta_desc'])}">
  <meta property="og:type" content="website">
  <meta property="og:locale" content="{bcp}">
  <meta property="og:image" content="{SITE_URL}/images/tvtroid-icon.png">

  <link rel="icon" href="{rel('favicon.ico', lang)}" sizes="any">
  <link rel="icon" type="image/png" href="{rel('images/tvtroid-icon.png', lang)}">
  <link rel="apple-touch-icon" href="{rel('images/apple-touch-icon.png', lang)}">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="{rel('assets/main.css', lang)}">
</head>
<body>

<header class="site-header">
  <div class="wrapper site-header__inner">
    <a class="site-title" href="{rel('index.html', lang)}">
      <img src="{rel('images/tvtroid-icon.png', lang)}" alt="TvTroid" class="site-title__logo">
      <span>TvTroid</span>
    </a>
    <nav class="site-nav">
      <a class="site-nav__link" href="#apps">{esc(t['nav_apps'])}</a>
      <a class="site-nav__link" href="#about">{esc(t['nav_about'])}</a>
{lang_switcher(lang)}      <a class="site-nav__link site-nav__cta" href="#apps">{esc(t['nav_cta'])}</a>
    </nav>
  </div>
</header>

<main class="page-content">

  <section class="hero">
    <div class="hero__glow" aria-hidden="true"></div>
    <div class="wrapper hero__inner">
      <p class="eyebrow reveal">{esc(t['eyebrow_hero'])}</p>
      <h1 class="hero__title reveal">
        {esc(t['hero_l1'])}<br>
        <span class="hero__title-accent">{esc(t['hero_l2'])}</span>
      </h1>
      <p class="hero__subtitle reveal">{esc(t['hero_sub'])}</p>
      <div class="hero__actions reveal">
        <a href="#apps" class="btn btn--primary">
          {esc(t['btn_explore'])}
          <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M3.5 8h9m0 0L8.5 4M12.5 8L8.5 12" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>
        </a>
        <a href="#about" class="btn btn--ghost">{esc(t['btn_learn'])}</a>
      </div>

      <div class="hero__stats reveal">
        <div class="stat">
          <span class="stat__number" data-count="217000">0</span>
          <span class="stat__label">{esc(t['stat_installs'])}</span>
        </div>
        <div class="stat">
          <span class="stat__number" data-count="4.6" data-decimal="1">0</span>
          <span class="stat__label">{esc(t['stat_rating'])}</span>
        </div>
        <div class="stat">
          <span class="stat__number" data-count="{len(APPS)}">0</span>
          <span class="stat__label">{esc(t['stat_apps'])}</span>
        </div>
      </div>
    </div>
  </section>

  <section class="apps" id="apps">
    <div class="wrapper">
      <div class="section-heading reveal">
        <p class="eyebrow">{esc(t['eyebrow_apps'])}</p>
        <h2>{esc(t['apps_h2'])}</h2>
        <p class="section-heading__subtitle">{esc(t['apps_sub'])}</p>
      </div>

      <div class="app-grid">

{cards}
      </div>
    </div>
  </section>

  <section class="about" id="about">
    <div class="wrapper about__inner">
      <div class="about__text reveal">
        <p class="eyebrow">{esc(t['eyebrow_about'])}</p>
        <h2>{esc(t['about_h2'])}</h2>
        <p>{esc(t['about_p'])}</p>
      </div>
      <div class="about__features reveal">
        <div class="feature">
          <div class="feature__icon">🚀</div>
          <h3>{esc(t['f1_h'])}</h3>
          <p>{esc(t['f1_p'])}</p>
        </div>
        <div class="feature">
          <div class="feature__icon">🎯</div>
          <h3>{esc(t['f2_h'])}</h3>
          <p>{esc(t['f2_p'])}</p>
        </div>
        <div class="feature">
          <div class="feature__icon">🔒</div>
          <h3>{esc(t['f3_h'])}</h3>
          <p>{esc(t['f3_p'])}</p>
        </div>
      </div>
    </div>
  </section>

  <section class="cta">
    <div class="wrapper cta__inner reveal">
      <h2>{esc(t['cta_h'])}</h2>
      <p>{esc(t['cta_p'])}</p>
      <a href="#apps" class="btn btn--primary btn--lg">
        {esc(t['cta_btn'])}
        <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M3.5 8h9m0 0L8.5 4M12.5 8L8.5 12" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>
      </a>
    </div>
  </section>

</main>

<footer class="site-footer">
  <div class="wrapper site-footer__inner">
    <div class="site-footer__brand">
      <img src="{rel('images/tvtroid-icon.png', lang)}" alt="TvTroid" class="site-footer__logo">
      <p>{esc(t['footer_tag'])}</p>
    </div>
    <div class="site-footer__links">
      <a href="mailto:contact.tvtroid@gmail.com">contact.tvtroid@gmail.com</a>
      <a href="{rel('privacy-policy/', lang)}">{esc(t['privacy'])}</a>
    </div>
  </div>
  <div class="wrapper site-footer__bottom">
    <p>&copy; <span id="year">2026</span> {esc(t['rights'])}</p>
  </div>
</footer>

<script src="{rel('assets/main.js', lang)}" defer></script>
</body>
</html>
"""


def main():
    written = []
    for code, _, bcp in LANGS:
        html = build_page(code, bcp)
        if code == "en":
            path = os.path.join(ROOT, "index.html")
        else:
            os.makedirs(os.path.join(ROOT, code), exist_ok=True)
            path = os.path.join(ROOT, code, "index.html")
        with open(path, "w", encoding="utf-8") as f:
            f.write(html)
        written.append(os.path.relpath(path, ROOT))

    # sitemap
    urls = "".join(
        f"  <url><loc>{SITE_URL}/{'' if c == 'en' else c + '/'}</loc></url>\n"
        for c, _, _ in LANGS
    )
    with open(os.path.join(ROOT, "sitemap.xml"), "w", encoding="utf-8") as f:
        f.write('<?xml version="1.0" encoding="UTF-8"?>\n'
                '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
                f"{urls}</urlset>\n")
    written.append("sitemap.xml")

    print("built:")
    for w in written:
        print("  ", w)


if __name__ == "__main__":
    main()
