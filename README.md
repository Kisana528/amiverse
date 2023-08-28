# 汎用マイクロブログSNSのようなもの
## 特徴
非中央集権・分散型SNSとして運用する機能があります。
文章に加え、画像・動画の投稿もできます。
投稿に多様なリアクションをつけられます。
## 本番環境構築方法
ダウンロード
```
$git clone https://github.com/Kisana528/amiverse.git
$chown -R user:group /amiverse
$git fetch origin main
$git reset --hard origin/main
```
app内bashに入る
```
$docker compose run --rm app bash
```
credentials作成
```
$$bundle
$$EDITOR="nano" rails credentials:edit
$$exit
```
Docker Composeで起動
```
$docker compose up -d --build
```
app内
```
$docker container exec -it amiverse-app-1 bash
```
db作成とマイグレート
```
$$rails db:create
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