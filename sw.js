'use strict';
const CACHE = 'study-desk-v10';
const CORE = ['./', './index.html', './dictionary.html', './excel-practice.html', './manifest.webmanifest', './icon.svg', './study-planner-icon.webp', './aaroh-symbol.jpg', './study-desk-icon.svg'];
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
    event.respondWith(fetch(request).then(async response => {
      if (!response || !response.ok) return response;
      const url = new URL(request.url);
      const canonical = new URL(url.pathname, self.registration.scope).toString();
      try {
        const cache = await caches.open(CACHE);
        // Cache canonical path only; navigation Request objects can have mode/cache
        // attributes that make them poor persistent cache keys across browser runs.
        await cache.put(canonical, response.clone());
        if (url.pathname.endsWith('/') || url.pathname.endsWith('/index.html')) {
          await cache.put(new URL('./index.html', self.registration.scope).toString(), response.clone());
          await cache.put(new URL('./', self.registration.scope).toString(), response.clone());
        }
      } catch {}
      return response;
    }).catch(async () => {
      const url = new URL(request.url);
      const canonical = new URL(url.pathname, self.registration.scope).toString();
      const cache = await caches.open(CACHE);
      return (await cache.match(canonical)) ||
        (await cache.match(request)) ||
        (await cache.match(new URL('./index.html', self.registration.scope).toString())) ||
        (await cache.match(new URL('./', self.registration.scope).toString()));
    }));
    return;
  }
  event.respondWith(fetch(request).then(async response => {
    if (!response || !response.ok) return response;
    try { await (await caches.open(CACHE)).put(request, response.clone()); } catch {}
    return response;
  }).catch(() => caches.match(request)));
});
