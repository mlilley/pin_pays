require_relative '../../spec_helper'


describe PinPays::Configuration do

  before do
    PinPays.configure do |config|
      config.key = 'testkey'
      config.mode = :test
    end
  end

  it "must have a configuration object on the module" do
    PinPays.configuration.wont_be_nil
    PinPays.configuration.must_be_instance_of PinPays::Configuration
  end

  it "must configure key" do
    PinPays.configuration.key.must_equal 'testkey'
  end

  it "must configure mode" do
    PinPays.configuration.mode.must_equal :test
  end

  it "must configure base_url on api class" do
    (PinPays::Api.base_uri).must_equal PinPays::Api::TEST_URI
  end

end