// /images/* へのリクエストだけがここに来る（wrangler.jsonc の run_worker_first）
// nginx.conf でやっていた WebP の出し分けを再現する
const RASTER_IMAGE = /\.(jpe?g|png)$/i;
// asset_hash でファイル名にハッシュが付くので長期キャッシュしてよい
const CACHE_CONTROL = 'public, max-age=31536000, immutable';

function withLongCache(response) {
  response = new Response(response.body, response);
  if (response.ok) response.headers.set('Cache-Control', CACHE_CONTROL);
  return response;
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (!RASTER_IMAGE.test(url.pathname)) {
      return withLongCache(await env.ASSETS.fetch(request));
    }

    // <img> での読み込みに限って WebP を返す
    // OGP のクローラーは Sec-Fetch-Dest を送らないので、常に元の JPG/PNG になる
    const acceptsWebp = (request.headers.get('Accept') || '').includes('image/webp');
    const isImageLoad = request.headers.get('Sec-Fetch-Dest') === 'image';

    let response;
    if (acceptsWebp && isImageLoad) {
      const webp = await env.ASSETS.fetch(new Request(new URL(`${url.pathname}.webp`, url), request));
      if (webp.ok || webp.status === 304) response = webp;
    }
    response ??= await env.ASSETS.fetch(request);

    response = withLongCache(response);
    response.headers.append('Vary', 'Accept');
    return response;
  },
};
