require 'spec_helper'

describe TaiwaneseNewsParser::Parser::LibertyTimes do
  describe '#parse' do
    before do
      Timecop.freeze(Time.local(2013,6,29,9,13))
    end
    it do
      url = 'http://iservice.libertytimes.com.tw/liveNews/news.php?no=829851&type=%E7%A4%BE%E6%9C%83&Slots=Live'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'liberty_times_s1.html'))
      article = described_class.new(url).parse
      article[:title].should == '又傳酒駕釀禍 少婦被撞陷昏迷'
      article[:content].should include('又傳酒駕釀禍！花蓮縣壽豐鄉一名男子昨天（28日）在友人家喝得爛醉')
      article[:company_name].should == '自由時報'
      article[:reporter_name].should == nil
      article[:published_at].should == Time.new(2013,6,29,17,52)
    end
  end
end

