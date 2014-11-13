require 'spec_helper'

describe TaiwaneseNewsParser::Parser::LibertyTimesNews do
  describe '#parse' do
    before do
      Timecop.freeze(Time.local(2013,6,29,9,13))
    end
    # layout at April 2014
    it do
      url = 'http://news.ltn.com.tw/news/politics/breakingnews/998126'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'liberty_times_news_s1.html'))
      article = described_class.new(url).parse
      article[:title].should == '義光禁食》林義雄宣布停止禁食 願再為台奮鬥'
      article[:content].should include('在今年的七合一選舉和來年的立委、總統選舉時，要求候選人承諾促成非核家園。')
      article[:company_name].should == '自由時報'
      article[:reporter_name].should == '李欣芳'
      article[:published_at].should == Time.new(2014,4,30,14,49,37)
    end
    it do
      url = 'http://news.ltn.com.tw/news/world/breakingnews/997893'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'liberty_times_news_s2.html'))
      article = described_class.new(url).parse
      article[:title].should == '震驚！中國勞改犯求救信藏百貨公司紙袋'
      article[:content].should include('紐約知名的薩克斯百貨公司')
      article[:company_name].should == '自由時報'
      article[:reporter_name].should == nil
      article[:published_at].should == Time.new(2014,4,30,10,57,57)
    end

    it do
      url = 'http://news.ltn.com.tw/news/society/breakingnews/829851'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'liberty_times_news_s3.html'))
      article = described_class.new(url).parse
      article[:title].should == '又傳酒駕釀禍 少婦被撞陷昏迷'
      article[:content].should include('又傳酒駕釀禍！花蓮縣壽豐鄉一名男子昨天（28日）在友人家喝得爛醉')
      article[:company_name].should == '自由時報'
      article[:reporter_name].should == nil
      article[:published_at].should == Time.new(2013,6,29,17,52,5)
    end
  end

  describe '#parse_url_id' do
    it do
      url = 'http://news.ltn.com.tw/news/politics/breakingnews/998126'
      described_class.parse_url_id(url).should == '998126'

      url = 'http://news.ltn.com.tw/news/world/breakingnews/997893'
      described_class.parse_url_id(url).should == '997893'
    end
  end
end
