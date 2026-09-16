var TvTroidLang = (function () {
  "use strict";

  var LANGS = ["en", "vi", "ja", "ko", "zh", "th", "es", "fr", "id", "el"];
  var KEY = "tvtroid_lang";

  // Directory segments of the current URL, ignoring any trailing filename.
  function segments() {
    var parts = location.pathname.split("/").filter(Boolean);
    if (parts.length && parts[parts.length - 1].indexOf(".") > -1) parts.pop();
    return parts;
  }

  // Language pages live at the site root or one directory below it, at
  // /<lang>/. Other pages (e.g. /privacy-policy/) are shared across all
  // languages and must not be treated as, or rewritten into, a lang page.
  function isLangPage() {
    var parts = segments();
    return parts.length === 0 || (parts.length === 1 && LANGS.indexOf(parts[0]) > -1);
  }

  function current() {
    var parts = segments();
    var last = parts[parts.length - 1];
    return LANGS.indexOf(last) > -1 ? last : "en";
  }

  function urlFor(code) {
    var parts = segments();
    if (current() !== "en") parts.pop();          // drop the language segment
    if (code !== "en") parts.push(code);
    return "/" + (parts.length ? parts.join("/") + "/" : "");
  }

  function go(code) {
    if (LANGS.indexOf(code) === -1) return;
    try { localStorage.setItem(KEY, code); } catch (e) {}
    if (code !== current()) location.href = urlFor(code);
  }

  // First visit: send the visitor to their browser's language if we have it.
  function autoRedirect() {
    if (!isLangPage()) return;
    var saved;
    try { saved = localStorage.getItem(KEY); } catch (e) {}
    if (saved) {
      if (saved !== current()) location.replace(urlFor(saved));
      return;
    }
    // Only auto-redirect from the English root, and never for a shared deep link.
    if (current() !== "en" || location.search || location.hash) return;
    var nav = (navigator.language || "en").slice(0, 2).toLowerCase();
    if (nav !== "en" && LANGS.indexOf(nav) > -1) {
      try { localStorage.setItem(KEY, nav); } catch (e) {}
      location.replace(urlFor(nav));
    }
  }

  autoRedirect();
  return { go: go, current: current };
})();

(function () {
  "use strict";

  var reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  var yearEl = document.getElementById("year");
  if (yearEl) yearEl.textContent = new Date().getFullYear();

  // Scroll reveal
  var revealEls = document.querySelectorAll(".reveal");
  if (reduceMotion || !("IntersectionObserver" in window)) {
    revealEls.forEach(function (el) { el.classList.add("is-visible"); });
  } else {
    var observer = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry, i) {
          if (entry.isIntersecting) {
            setTimeout(function () {
              entry.target.classList.add("is-visible");
            }, i * 60);
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.12, rootMargin: "0px 0px -40px 0px" }
    );
    revealEls.forEach(function (el) { observer.observe(el); });
  }

  // Animated stat counters
  var stats = document.querySelectorAll(".stat__number");
  if (stats.length && !reduceMotion && "IntersectionObserver" in window) {
    var statObserver = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (!entry.isIntersecting) return;
          animateCount(entry.target);
          statObserver.unobserve(entry.target);
        });
      },
      { threshold: 0.6 }
    );
    stats.forEach(function (el) { statObserver.observe(el); });
  } else {
    stats.forEach(function (el) { setFinalValue(el); });
  }

  function animateCount(el) {
    var target = parseFloat(el.getAttribute("data-count"));
    var decimals = parseInt(el.getAttribute("data-decimal") || "0", 10);
    var duration = 1200;
    var start = null;

    function step(timestamp) {
      if (start === null) start = timestamp;
      var progress = Math.min((timestamp - start) / duration, 1);
      var eased = 1 - Math.pow(1 - progress, 3);
      var value = target * eased;
      el.textContent = formatValue(value, decimals);
      if (progress < 1) {
        requestAnimationFrame(step);
      } else {
        setFinalValue(el);
      }
    }
    requestAnimationFrame(step);
  }

  function setFinalValue(el) {
    var target = parseFloat(el.getAttribute("data-count"));
    var decimals = parseInt(el.getAttribute("data-decimal") || "0", 10);
    el.textContent = formatValue(target, decimals);
  }

  function formatValue(value, decimals) {
    if (decimals > 0) return value.toFixed(decimals);
    var rounded = Math.round(value);
    return rounded >= 1000 ? rounded.toLocaleString("en-US") + "+" : String(rounded);
  }
})();
