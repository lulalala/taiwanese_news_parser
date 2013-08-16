require 'spec_helper'

describe TaiwaneseNewsParser::Parser::LibertyTimesBig5 do
  describe '#parse' do
    it do
      url = 'http://www.libertytimes.com.tw/2013/new/jun/29/today-t2.htm?Slots=T'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'liberty_times_big5_s1.html'))
      article = described_class.new(url).parse
      article[:title].should == '果汁？啤酒？難分 「飲誘」青少年'
      article[:content].should include('市面上出現愈來愈多以水果口味為賣點的啤酒')
      article[:company_name].should == '自由時報'
      article[:reporter_name].should == '施曉光、吳亮儀、陳慧萍'
      article[:published_at].should == Time.new(2013,6,29)
    end
  end

  describe '#parse_url_id' do
    it do
      url = 'http://www.libertytimes.com.tw/2013/new/jun/29/today-sp1-3.htm'
      described_class.parse_url_id(url).should == '2013/new/jun/29/today-sp1-3'
    end
    it do
      url = 'http://www.libertytimes.com.tw/2013/new/jun/29/today-so10.htm'
      described_class.parse_url_id(url).should == '2013/new/jun/29/today-so10'
    end
    it do
      url = 'http://www.libertytimes.com.tw/2013/new/jun/29/today-int4.htm'
      described_class.parse_url_id(url).should == '2013/new/jun/29/today-int4'
    end
  end
end
