require_relative '../../spec_helper'

describe PinPays::Cards do

  before do
    PinPays.configure do |config|
      config.key  = SECRET_KEY
      config.mode = :test
    end

  end

  describe "create" do

    before do
      VCR.use_cassette('cards-create') do
        @result = PinPays::Cards.create({
          number: '5520000000000000',
          expiry_month: '12',
          expiry_year: '2020',
          cvc: '123',
          name: 'Mr Test Case',
          address_line1: '1 Long St',
          address_line2: '',
          address_city: 'Somewhereville',
          address_postcode: '30000',
          address_state: 'Somewherestate',
          address_country: 'Australia'
        })
      end
    end

    it "must include card token in result" do
      @result[:token].wont_be_nil
      @result[:token].must_be_instance_of String
    end

  end

end