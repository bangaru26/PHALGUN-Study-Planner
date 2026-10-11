'use strict';
const CACHE = 'phalgun-study-planner-v2';
const CORE = ['./', './index.html', './manifest.webmanifest', './icon.svg', './study-planner-icon.webp'];
self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE).then(cache => cache.addAll(CORE)).then(() => self.skipWaiting()));
});
self.addEventListener('activate', event => {
  event.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(key => key.startsWith('aaroh-study-desk-') && key !== CACHE).map(key => caches.delete(key)))).then(() => self.clients.claim()));
});
self.addEventListener('fetch', event => {
  const request = event.request;
  if (request.method !== 'GET' || new URL(request.url).origin !== self.location.origin) return;
  if (request.mode === 'navigate') {
    event.respondWith(fetch(request).then(response => {
      const copy = response.clone();
      caches.open(CACHE).then(cache => cache.put('./index.html', copy));
      return response;
    }).catch(() => caches.match('./index.html').then(cached => cached || caches.match('./'))));
    return;
  }
  event.respondWith(caches.match(request).then(cached => {
    const network = fetch(request).then(response => {
      if (response && response.ok) caches.open(CACHE).then(cache => cache.put(request, response.clone()));
      return response;
    });
    return cached || network;
  }));
});