require_relative '../../spec_helper'


describe PinPays::Refunds do

  before do
    PinPays.configure do |config|
      config.key  = SECRET_KEY
      config.mode = :test
    end

    card_token = nil
    VCR.use_cassette('cards-create') do
      card = PinPays::Cards.create({
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
      @card_token = card[:token]
    end

    VCR.use_cassette('customers-create') do
      customer = PinPays::Customers.create('test@example.com', @card_token)
      @customer_token = customer[:token]
    end

    VCR.use_cassette('charges-create') do
      charge = PinPays::Charges.create({
        customer_token: @customer_token,
        email: 'test@example.com',
        description: 'Flux Capacitor (box of 10)',
        amount: 9995,
        ip_address: '127.0.0.1',
        capture: true
      })
      @charge_token = charge[:token]
    end
  end


  describe "create" do
    before do
      VCR.use_cassette('refunds-create') do
        @refund = PinPays::Refunds.create(@charge_token)
      end
    end

    it "must include refund token in result" do
      @refund[:token].wont_be_nil
      @refund[:token].must_be_instance_of String
    end

    it "must include original charge token in result" do
      @refund[:charge].must_equal @charge_token
    end
  end


  describe "list" do
    before do
      VCR.use_cassette('refunds-list') do
        @list = PinPays::Refunds.list(@charge_token)
      end
    end

    it "must return an array result" do
      @list.must_be_instance_of Array
    end
  end

end