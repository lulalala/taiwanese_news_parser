# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'taiwanese_news_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "taiwanese_news_parser"
  spec.version       = TaiwaneseNewsParser::VERSION
  spec.authors       = ["lulalala"]
  spec.email         = ["mark@goodlife.tw"]
  spec.description   = %q{台灣各新聞網站新聞解析器}
  spec.summary       = %q{台灣各新聞網站新聞解析器}
  spec.homepage      = "https://github.com/lulalala/taiwanese_news_parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.6"
  spec.add_development_dependency "fakeweb", "~> 1.3"

  spec.add_dependency 'addressable', '~> 2.0'
  spec.add_dependency 'nokogiri', '~> 1.5'
end
