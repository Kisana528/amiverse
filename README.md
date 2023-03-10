# アプリ作成

ブログで手順公開。

## 汎用SNSです
アカウント、投稿機能あります。
ブロックチェーンに対応したいです。

```
rails db:migrate:status
rails db:migrate:down VERSION=
rails db:rollback STEP=X
```
javascript_importmap_tagsをjavascript_include_tagへ変更

amiverse\src\app\helpers\sessions_helper.rb
cookieのsecure設定

本番で強制
```
sudo chown -R kisana:kisana ~/amiverse
git fetch origin main
git reset --hard origin/main
```