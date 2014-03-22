require 'spec_helper'

describe TaiwaneseNewsParser::Parser::Cts do
  describe '#parse' do
    before do
      Timecop.freeze(Time.local(2013,6,29,9,13))
    end
    it do
      url = 'http://news.cts.com.tw/cts/politics/201403/201403191393958.html'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'cts_s1.html'))
      article = described_class.new(url).parse
      article[:title].should == '為何反服貿? 抗議學生搞不清'
      article[:content].should include('因為反黑箱服貿，學生霸佔國會')
      article[:company_name].should == '華視'
      article[:reporter_name].should == '彭佳芸 黃翊真'
      article[:published_at].should == Time.new(2014,3,19,18,58)
    end
    it do
      url = 'http://news.cts.com.tw/nownews/politics/201403/201403221395428.html'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'cts_s2.html'))
      article = described_class.new(url).parse
      article[:title].should == '學生要求馬英九對話　總統府：不會接受'
      article[:content].should include('但是學生用這種方式要求對話，府方不會接受。')
      article[:company_name].should == '華視'
      article[:reporter_name].should == nil
      article[:published_at].should == Time.new(2014,3,22,10,9)
    end
  end

  describe '#parse_url_id' do
    it do
      url = 'http://news.cts.com.tw/cts/politics/201403/201403191393958.html'
      described_class.parse_url_id(url).should == '201403191393958'
    end
  end
end
