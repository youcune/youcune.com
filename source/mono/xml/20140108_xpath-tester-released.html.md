---
title: XPathのテストツールつくりました
date: 2014-01-08
tags: xml
---

### XPathをどうテストするか

XPathってちょっとむつかしくないですか？　あれこの書き方で要素取れるのかな、とか、知りたくなったりしませんか？　みんなこういうときってどうやってテストしてるのでしょうか。。テストのしかたがよく分からなかったのでテストツール[XPath Tester](https://github.com/youcune/xpath-tester/)をを作ってみました。

いちおう動くレベルです。必要ないかもしれへんけどテストコードとエラーハンドリングとかの部分は近日更新します。

### 使い方

```bash
$ git clone https://github.com/youcune/xpath-tester.git
$ cd xpath-tester
$ bundle install --path vendor/bundle
$ bundle exec rails s
```

として、 [http://localhost:3000/](http://localhost:3000/) にアクセスすれば試せると思います。コードはREXMLを呼び出しているだけなので実質1行ですｗ
