# これは何?

各電鉄会社の遅延証明書のページをクロールして、S3に貯めこむアプリです


# 必要なもの

- [PhantomJS](http://phantomjs.org/)

# 使い方

環境変数に以下を設定

```
AWS_ACCESS_KEY
AWS_SECRET_ACCESS_KEY
AWS_REGION
BUCKET
WEBHOOK_URL (slack 通知が欲しければ)
```

```
bundle exec main.rb
```

これで、S3に電鉄会社毎のディレクトリが作られて、そこに遅延証明書が貯めこまれます

# 対応電鉄会社

- 小田急線

# 電鉄会社追加方法

1. `crawler/seibu.rb` のように、電鉄会社毎のファイルを作る
1. `Crawler` を継承したクラスを作る
1. 各遅延証明書のURLと日時を配列で返す `#crawl` メソッドを作成する

_crawler/odakyu.rb を参考にしてね_
