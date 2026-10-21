'use strict';
const CACHE = 'study-desk-v7';
const CORE = ['./', './index.html', './dictionary.html', './excel-practice.html', './manifest.webmanifest', './icon.svg', './study-planner-icon.webp', './aaroh-symbol.jpg', './study-desk-icon.svg'];
self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE).then(cache => cache.addAll(CORE)).then(() => self.skipWaiting()));
});
self.addEventListener('activate', event => {
  event.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(key => (key.startsWith('aaroh-study-desk-') || key.startsWith('phalgun-study-planner-') || key.startsWith('study-desk-')) && key !== CACHE).map(key => caches.delete(key)))).then(() => self.clients.claim()));
});
self.addEventListener('fetch', event => {
  const request = event.request;
  if (request.method !== 'GET' || new URL(request.url).origin !== self.location.origin) return;
  if (request.mode === 'navigate') {
    event.respondWith(fetch(request).then(response => {
      if (!response || !response.ok) return response;
      const copy = response.clone();
      return caches.open(CACHE).then(cache => cache.put('./index.html', copy)).then(() => response);
    }).catch(() => caches.match('./index.html').then(cached => cached || caches.match('./'))));
    return;
  }
  event.respondWith(fetch(request).then(response => {
    if (!response || !response.ok) return response;
    const copy = response.clone();
    return caches.open(CACHE).then(cache => cache.put(request, copy)).then(() => response);
  }).catch(() => caches.match(request)));
});