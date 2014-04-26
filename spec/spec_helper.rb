require File.expand_path('../../lib/pin_pays.rb', __FILE__)

require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'
require 'turn'

#SECRET_KEY = 'your-pinpayments-secret-key'

Turn.config do |c|
  c.format  = :outline
  c.trace   = true
  c.natural = true
  c.verbose = true
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr'
  c.hook_into :webmock
  c.filter_sensitive_data('<SECRET_KEY>') { SECRET_KEY }
end

