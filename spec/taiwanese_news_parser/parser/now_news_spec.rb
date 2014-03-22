require 'spec_helper'

describe TaiwaneseNewsParser::Parser::NowNews do
  describe '#parse' do
    it do
      url = 'http://www.nownews.com/n/2014/03/21/1159861'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'now_news_s1.html'))
      article = described_class.new(url).parse
      article[:title].should == '軍警強攻立院傳聞四起　總統府：不可能！'
      article[:content].should include('青年占領立法院反服貿活動持續進行，學生代表林飛帆21日晚間召開記者會表示')
      article[:content].should include('但採取激烈的方式，社會各界均不樂見。')
      article[:company_name].should == 'NowNews'
      article[:reporter_name].should == '王鼎鈞'
      article[:published_at].should == Time.new(2014,3,21,20,36)
    end
    it do
      url = 'http://www.nownews.com/n/2014/03/20/1156607'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'now_news_s2.html'))
      article = described_class.new(url).parse
      article[:title].should == '劉興武跳脫傳統經營　金漢柿餅園區轉型觀光休閒'
      article[:content].should include('新埔鎮旱坑里金漢柿餅產業文化園區由劉金漢於民國三十六年始創')
      article[:reporter_name].should == '房書勤'
      article[:published_at].should == Time.new(2014,3,20,0,43)
    end
  end
  describe '.parse_url_id' do
    it do
      described_class.parse_url_id('http://www.nownews.com/n/2014/03/21/1159861').should == '1159861'
    end
  end
end
