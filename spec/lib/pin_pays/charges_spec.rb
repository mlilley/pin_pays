require_relative '../../spec_helper'


def create_charge(customer_token)
  charge = nil
  VCR.use_cassette('charges-create') do
    charge = PinPays::Charges.create({
      customer_token: customer_token,
      email: 'test@example.com',
      description: 'Flux Capacitor (box of 10)',
      amount: 9995,
      ip_address: '127.0.0.1',
      capture: true
    })
  end
  charge
end


def create_preauth(customer_token)
  charge = nil
  VCR.use_cassette('charges-create-preauth') do
    charge = PinPays::Charges.create({
      email: 'test@example.com',
      description: 'Flux Capacitor (box of 10)',
      amount: 9995,
      ip_address: '127.0.0.1',
      capture: false
    })
  end
  charge
end


describe PinPays::Charges do

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
      card_token = card[:token]
    end

    VCR.use_cassette('customers-create') do
      customer = PinPays::Customers.create('test@example.com', card_token)
      @customer_token = customer[:token]
    end
  end


  describe "create" do
    before do
      @charge = create_charge(@customer_token)
    end

    it "must include charge token in result" do
      @charge[:token].wont_be_nil
      @charge[:token].must_be_instance_of String
    end
  end


  # describe "capture" do
  # end


  describe "list" do
    before do
      VCR.use_cassette('charges-list') do
        @list = PinPays::Charges.list()
      end
    end

    it "must return a pagination style result" do
      @list[:items].wont_be_nil
      @list[:items].must_be_instance_of Array
      @list[:pages].wont_be_nil
      @list[:pages].must_be_instance_of Hash
    end
  end


  # describe "search" do
  # end


  describe "show" do
    before do
      @charge = create_charge(@customer_token)
      VCR.use_cassette('charges-show') do
        @show = PinPays::Charges.show(@charge[:token])
      end
    end

    it "must include requested charges's token in result" do
      @show[:token].wont_be_nil
      @show[:token].must_be_instance_of String
      @show[:token].must_equal @charge[:token]
    end
  end


# todo - test the more exotic alternative ways to create a charge, and
#        verify the non-success modes using pin-payment's sentinal card values


end