# アプリ作成
ブログで手順公開。
## 汎用SNSです
アカウント、投稿機能あります。
ブロックチェーンに対応したいです。
## 本番構築
```
git clone https://github.com/Kisana528/amiverse.git
chown -R kisana:kisana /amiverse
git fetch origin main
git reset --hard origin/main
docker-compose down
docker-compose up -d --build
docker container exec -it amiverse_app_1 bash
rails db:create &&
rails db:seed &&
```
## 将来実装したい
- Redis(セッションなど管理)
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