# youcune.com

MiddleMan プロジェクトです。 `build` 時に WebP 画像を自動生成するので、 `cwebp` コマンドが必要です。

## デプロイ

`main` に push すると GitHub Actions（`.github/workflows/deploy.yml`）がビルドし、`build/` を Cloudflare Workers の Static Assets にデプロイします。

- 設定は `wrangler.jsonc` にあります。
- 旧 URL のリダイレクトはリポジトリ直下の `_redirects` に書きます（ビルド時に `build/` へコピーされます）。
- `/images/*` だけ `worker/index.js` を通り、ブラウザの `<img>` 読み込みで WebP に対応していれば `*.jpg.webp` / `*.png.webp` を返します。OGP のクローラーには元の JPG/PNG を返します。
- GitHub の Secrets に `CLOUDFLARE_API_TOKEN` と `CLOUDFLARE_ACCOUNT_ID` が必要です。

ローカルで確認する場合:

```sh
bundle exec middleman build
npx wrangler dev
```
