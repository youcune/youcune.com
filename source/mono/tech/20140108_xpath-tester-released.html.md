---
title: XPathのテストツールつくりました
date: 2014-01-08
tags: Tech,XML,XPath
---

### XPathをどうテストするか

XPathってちょっとむつかしくないですか？　あれこの書き方で要素取れるのかなとか知りたくなったりしませんか？　みんなこういうときってどうやってテストしてるのでしょうか。。テストのしかたがよく分からなかったのでテストツール[XPath Tester](https://github.com/youcune/xpath-tester/)を作ってみました。

いちおう動くレベルです。必要ないかもしれへんけどテストコードとエラーハンドリングとかの部分をいまつくっているのでまたそのうちPushします。

### 使い方

* Ruby 2.x がインストールされていること
* bundler がインストールされていること

が前提です。    

```bash
$ git clone https://github.com/youcune/xpath-tester.git
$ cd xpath-tester
$ bundle install --path vendor/bundle --without development test
$ bundle exec rails server -e production
```

として、 [http://localhost:3000/](http://localhost:3000/) にアクセスすれば試せると思います。コードはREXMLを呼び出しているだけなので実質1行ですｗ
