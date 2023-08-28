# 汎用マイクロブログSNSのようなもの
## 特徴
非中央集権・分散型SNSとして運用する機能があります。
文章に加え、画像・動画の投稿もできます。
投稿に多様なリアクションをつけられます。
## 本番環境構築方法
ダウンロード
```
$git clone https://github.com/Kisana528/amiverse.git
$chown -R user:group amiverse
$cd amiverse
$git fetch origin main
$git reset --hard origin/main
```
app内bashに入る
```
$docker compose run app bash
```
credentials作成
```
$$bundle
$$EDITOR="mate --wait" rails credentials:edit
```
db作成とマイグレート
```
$$rails db:create
$$rails db:migrate
```
seedあれば./src/db/seeds.rbを保存後
```
$$rails db:seed
```
閉じる
```
$$exit
```
Docker Composeで起動
```
$docker compose up -d --build
```
以上で完了。
## メンテ
compose起動中app内に入るには
```
$docker container exec -it amiverse-app-1 bash
```
ログを確認するには
```
$docker compose logs --follow --tail '1000'
```
## 実装予定
- Redis(揮発性メモリ上でデータ管理)
- Es(検索最適化)

## 開発ルール
### ブランチ
- main - プロダクションとして公開するもの
- develop - 開発中
- release - 次期main候補
- feature/* - 新規開発
- hotfix/* - バグ対処
- fix/* - 改善
- support/* - 過去バージョン
### コミットメッセージ
```
[種別] 内容の要約
内容...
```
- fix
- hotfix
- add
- update
- change
- clean
- disable
- remove
- upgrade
- revert