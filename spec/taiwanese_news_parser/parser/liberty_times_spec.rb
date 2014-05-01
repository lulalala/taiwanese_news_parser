require 'spec_helper'

describe TaiwaneseNewsParser::Parser::LibertyTimes do
  describe '#parse' do
    before do
      Timecop.freeze(Time.local(2013,6,29,9,13))
    end
  end

  describe '#parse_url_id' do
    it do
      url = 'http://iservice.libertytimes.com.tw/liveNews/news.php?no=854755&Slots=Live'
      described_class.parse_url_id(url).should == '854755'

      url = 'http://iservice.libertytimes.com.tw/liveNews/news.php?no=854838&type=%E5%9C%8B%E9%9A%9B'
      described_class.parse_url_id(url).should == '854838'
    end
  end
end
