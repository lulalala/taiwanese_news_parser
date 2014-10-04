# TaiwaneseNewsParser

台灣各新聞網站新聞解析器

## 給平常不用 Ruby 的人的使用法：

### 安裝

請先安裝 Ruby，本程式庫支援 Ruby 1.9 以上。

接著請在 shell 執行：

    gem install taiwanese_news_parser

### 使用

在 shell 裡面執行：

    taiwanese_news_parser "[網址]"

即會印出網址分析的 JSON ，比如：

    {"url":"http://iservice.ltn.com.tw/2014/specials/nonukes/news.php?no=998123","web_domain":"libertytimes.com.tw","url_id":null,"title":"民眾行為脫序 內政部：將更強勢執法","company_name":"自由時報","content":"〔本報訊〕反核民眾近來動作頻頻，許多脫序的行為已明顯違法，內政部次長陳純敬表示...(略)","published_at":"2014-04-30 15:13:00 +0800","reporter_name":null,"reproduced":false}


## 給對 Ruby 比較熟悉的人的使用法：

### 安裝

在 Gemfile 裡面加入這行：

    gem 'taiwanese_news_parser'

然後執行

    bundle install

### 呼叫

    TaiwaneseNewsParser.parse(url)

會回傳新聞資訊的 hash

## 使用實例

* [新聞糾正](http://news.1dv.tw)

## Contributing

想要協助的朋友可以幫忙為其他新聞網站寫解析器。實作細節請參考個別解析器以及[wiki](https://github.com/lulalala/taiwanese_news_parser/wiki)。

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
