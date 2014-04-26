require File.expand_path('../lib/pin_pays/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'pin_pays'
  s.version     = PinPays::VERSION
  s.licenses    = ['MIT']
  s.summary     = "Pin Payments API Implementation for Ruby and Rails"
  s.description = "Provides an implementation of the Pin Payments API (pin.com.au) for Ruby and Rails projects"
  s.authors     = ["Michael Lilley"]
  s.email       = 'mike@mlilley.com'
  s.homepage    = 'https://github.com/mlilley/pin_pays'

  s.add_dependency "httparty", "~> 0.13"

  s.add_development_dependency "webmock", '~> 1.17'
  s.add_development_dependency "vcr",     '~> 2.9'
  s.add_development_dependency "turn",    '~> 0.9'
  s.add_development_dependency "rake",    '~> 10.3'

  s.files       = `git ls-files`.split("\n")
end