# Heroku に、ruby と、 PhantomJS のビルドパックを混在させる

## 初手

```
heroku create
heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git
```

## .buildpacks を作る

```.buildpacks
https://github.com/heroku/heroku-buildpack-ruby
https://github.com/stomita/heroku-buildpack-phantomjs
```

## PATHを切る

```
heroku config:set PATH="/usr/local/bin:/usr/bin:/bin:/app/vendor/phantomjs/bin"
heroku config:set LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib:/app/vendor/phantomjs/lib
```

## その他環境変数を設定

```
heroku config:set AWS_ACCESS_KEY=*********
heroku config:set AWS_SECRET_ACCESS_KEY=*********
heroku config:set AWS_REGION=*********
heroku config:set BUCKET=*********
```

## 動作確認

```
heroku run "ruby main.rb"
```

## 文字化けした!!

日本語フォントを用意する必要があるらしい

`./fonts/` に[Ume-font](https://osdn.jp/projects/ume-font/wiki/FrontPage) を追加

- 参考 : [heroku で phantomjs を使用した時に日本語が文字化けするのを解決する - C++でゲームプログラミング](http://d.hatena.ne.jp/osyo-manga/20130626/1372210417)

## 参考

- https://gist.github.com/edelpero/9257311
