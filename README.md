# tvtroid.github.io

The app list moved to **https://nihicode.com/apps** (2026-10-31). Each app now has its own
site under nihicode.com (toeic, vstep, crackthecode, chess, habit, finicky).

What is left here, and why it must stay:

- `index.html` and `<lang>/index.html`: redirect stubs to nihicode.com/apps (GitHub Pages
  can't send a 301, so they use a canonical link, a meta refresh and `location.replace`).
- `app-ads.txt`: ad networks read it from the developer website set in the store listings.
  Don't remove it until every store listing's website points elsewhere and has its own copy.
- `privacy-policy/` and `privacy-policy.html`: linked from store listings and older app builds.
- `404.html`.

`site/build.py` used to generate the app list pages. Don't run it: it would overwrite the
redirects. The app list is now edited in the NiHi-Code repo (`src/content/apps.ts`).
