/* ===================================================================
 *  SERVICE WORKER — chỉ cache tài nguyên CDN (three.js, 3d-force-graph,
 *  Tailwind, Font Awesome) + icon/manifest tĩnh để mở app nhanh hơn.
 *
 *  KHÔNG đụng vào trang HTML và /api (tránh rắc rối với đăng nhập
 *  và dữ liệu cũ) — các request đó luôn đi thẳng ra mạng.
 * =================================================================== */
const CACHE = "kg-static-v1";
const CDN_HOSTS = ["esm.sh", "cdn.tailwindcss.com", "cdnjs.cloudflare.com"];

self.addEventListener("install", () => self.skipWaiting());

self.addEventListener("activate", (e) => {
  // Dọn cache phiên bản cũ khi đổi tên CACHE
  e.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", (e) => {
  if (e.request.method !== "GET") return;
  const url = new URL(e.request.url);

  const isCdn = CDN_HOSTS.includes(url.host);
  const isStatic = url.origin === location.origin &&
    (url.pathname.startsWith("/icons/") || url.pathname === "/manifest.webmanifest");
  if (!isCdn && !isStatic) return;      // HTML + /api: luôn ra mạng

  // Cache-first: có trong cache thì trả ngay, chưa có thì tải rồi lưu lại
  e.respondWith(
    caches.open(CACHE).then(async (cache) => {
      const hit = await cache.match(e.request);
      if (hit) return hit;
      const res = await fetch(e.request);
      if (res.ok || res.type === "opaque") cache.put(e.request, res.clone());
      return res;
    })
  );
});
