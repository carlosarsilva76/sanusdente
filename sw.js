const CACHE='sanusdente-v1';
const SHELL=['./','./index.html','./manifest.json','./icon-192.png','./icon-512.png','./apple-touch-icon.png'];
self.addEventListener('install',e=>{e.waitUntil(caches.open(CACHE).then(c=>c.addAll(SHELL)).then(()=>self.skipWaiting()));});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(k=>Promise.all(k.filter(x=>x!==CACHE).map(x=>caches.delete(x)))).then(()=>self.clients.claim()));});
self.addEventListener('fetch',e=>{const req=e.request,url=req.url; if(url.includes('supabase.co')||url.includes('cdn.')||url.includes('fonts.'))return; const isHTML=req.mode==='navigate'||url.endsWith('/')||url.endsWith('index.html')||url.endsWith('manifest.json'); if(isHTML){e.respondWith(fetch(req).then(r=>{const c=r.clone();caches.open(CACHE).then(ca=>ca.put(req,c));return r;}).catch(()=>caches.match(req).then(r=>r||caches.match('./index.html'))));}else{e.respondWith(caches.match(req).then(r=>r||fetch(req)));}});
