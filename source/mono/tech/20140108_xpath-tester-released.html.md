---
title: XPathのテストツールつくりました
date: 2014-01-08
tags: Tech,XML,XPath
description: XPathのテストツールをGithubに公開したので紹介します
---

### XPathをどうテストするか

XPathってちょっとむつかしくないですか？　あれこの書き方で要素取れるのかなとか知りたくなったりしませんか？　みんなこういうときってどうやってテストしてるのでしょうか。。テストのしかたがよく分からなかったのでテストツール [XPath Tester](http://xpath-tester.herokuapp.com/) を作ってみました。

### ソースコード

[GitHub](https://github.com/youcune/xpath-tester/) にあります。自分で動かすには下記のようにします。

* Ruby 2.x がインストールされていること
* bundler がインストールされていること

が前提です。    

```bash
$ git clone https://github.com/youcune/xpath-tester.git
$ cd xpath-tester
$ bundle install --path vendor/bundle
$ bundle exec rails server
```

として、 [http://localhost:3000/](http://localhost:3000/) にアクセスすれば試せると思います。コードは REXML を呼び出しているだけなのでほとんど中身ないですｗ
