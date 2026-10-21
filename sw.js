'use strict';
const CACHE = 'study-desk-v9';
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
    event.respondWith(fetch(request).then(response => {
      if (!response || !response.ok) return response;
      const copy = response.clone();
      const url = new URL(request.url);
      const canonical = new URL(url.pathname, self.registration.scope).toString();
      return caches.open(CACHE).then(cache => {
        const writes = [cache.put(request, copy), cache.put(canonical, copy.clone())];
        if (url.pathname.endsWith('/') || url.pathname.endsWith('/index.html')) {
          writes.push(cache.put(new URL('./index.html', self.registration.scope).toString(), copy.clone()));
          writes.push(cache.put(new URL('./', self.registration.scope).toString(), copy.clone()));
        }
        return Promise.all(writes).catch(() => undefined).then(() => response);
      }).catch(() => response);
    }).catch(() => {
      const url = new URL(request.url);
      const canonical = new URL(url.pathname, self.registration.scope).toString();
      return caches.match(request).then(cached =>
        cached || caches.match(canonical).then(page =>
          page || caches.match('./index.html').then(shell => shell || caches.match('./'))
        )
      );
    }));
    return;
  }
  event.respondWith(fetch(request).then(response => {
    if (!response || !response.ok) return response;
    const copy = response.clone();
    return caches.open(CACHE).then(cache => cache.put(request, copy)).catch(() => undefined).then(() => response);
  }).catch(() => caches.match(request)));
});
