'use strict';
const CACHE = 'study-desk-v11';
const CORE = ['./', './index.html', './dictionary.html', './excel-practice.html', './manifest.webmanifest', './icon.svg', './study-planner-icon.webp', './aaroh-symbol.jpg', './study-desk-icon.svg'];
const scopedUrl = path => new URL(path, self.registration.scope).toString();
self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE).then(cache => cache.addAll(CORE)).then(() => self.skipWaiting()));
});
self.addEventListener('activate', event => {
  event.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(key =>
    (key.startsWith('aaroh-study-desk-') || key.startsWith('phalgun-study-planner-') || key.startsWith('study-desk-')) && key !== CACHE
  ).map(key => caches.delete(key)))).then(() => self.clients.claim()));
});
self.addEventListener('fetch', event => {
  const request = event.request;
  if (request.method !== 'GET' || new URL(request.url).origin !== self.location.origin) return;
  if (request.mode === 'navigate') {
    event.respondWith((async () => {
      const url = new URL(request.url);
      // Build keys relative to the GitHub Pages app scope, not the origin root.
      const scopePath = new URL(self.registration.scope).pathname;
      const relativePath = url.pathname.startsWith(scopePath) ? url.pathname.slice(scopePath.length) : url.pathname.replace(/^\\//, '');
      const canonical = scopedUrl(relativePath || './');
      try {
        const response = await fetch(request);
        if (!response || !response.ok) return response;
        const cache = await caches.open(CACHE);
        // Store stable URL keys without query strings; ignoreSearch also supports
        // navigations whose test/session URL includes a cache-busting query.
        await cache.put(canonical, response.clone());
        if (!relativePath || relativePath === 'index.html') {
          await cache.put(scopedUrl('./index.html'), response.clone());
          await cache.put(scopedUrl('./'), response.clone());
        }
        return response;
      } catch {
        const cache = await caches.open(CACHE);
        const hit = await cache.match(canonical, {ignoreSearch: true}) ||
          await cache.match(request, {ignoreSearch: true});
        if (hit) return hit;
        // Only the home route may fall back to the app shell. Never show the
        // Study Desk home page as a misleading substitute for another module.
        if (!relativePath || relativePath === 'index.html') {
          return await cache.match(scopedUrl('./index.html')) ||
            await cache.match(scopedUrl('./'));
        }
        return new Response('This PHALGUN page is not available offline yet. Open it once while online, then retry.', {
          status: 503, headers: {'Content-Type': 'text/plain; charset=utf-8'}
        });
      }
    })());
    return;
  }
  event.respondWith(fetch(request).then(async response => {
    if (!response || !response.ok) return response;
    try { await (await caches.open(CACHE)).put(request, response.clone()); } catch {}
    return response;
  }).catch(() => caches.match(request, {ignoreSearch: true})));
});
