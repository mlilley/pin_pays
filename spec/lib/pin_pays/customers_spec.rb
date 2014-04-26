require_relative '../../spec_helper'


def create_customer(card_token)
  customer = nil
  VCR.use_cassette('customers-create') do
     customer = PinPays::Customers.create('test@example.com', card_token)
  end
  customer
end


describe PinPays::Customers do

  before do
    PinPays.configure do |config|
      config.key  = SECRET_KEY
      config.mode = :test
    end
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
  end


  describe "create" do

    before do
      @customer = create_customer(@card_token)
    end

    it "must include customer token in result" do
      @customer[:token].wont_be_nil
      @customer[:token].must_be_instance_of String
    end

  end


  describe "list" do

    before do
      @customer = create_customer(@card_token)
      VCR.use_cassette('customers-list') do
        @list = PinPays::Customers.list()
      end
    end

    it "must return a pagination style result" do
      @list[:items].wont_be_nil
      @list[:items].must_be_instance_of Array
      @list[:pages].wont_be_nil
      @list[:pages].must_be_instance_of Hash
    end

  end


  describe "show" do

    before do
      @customer = create_customer(@card_token)
      VCR.use_cassette('customers-show') do
        @show = PinPays::Customers.show(@customer[:token])
      end
    end

    it "must include requested customer's token in result" do
      @show[:token].wont_be_nil
      @show[:token].must_be_instance_of String
      @show[:token].must_equal @customer[:token]
    end

  end


  describe "update" do

    before do
      @customer = create_customer(@card_token)
      @updated_email = 'foo@bar.com'
      VCR.use_cassette('customers-update') do
        @update = PinPays::Customers.update(@customer[:token], { email: @updated_email })
      end
    end

    it "must include requested customer's token in result" do
      @update[:token].wont_be_nil
      @update[:token].must_be_instance_of String
      @update[:token].must_equal @customer[:token]
    end

    it "must include updated email in result" do
      @update[:email].must_equal @updated_email
    end

  end


  describe "charges" do

    before do
      @customer = create_customer(@card_token)
      VCR.use_cassette('customers-charges') do
        @charges = PinPays::Customers.charges(@customer[:token])
      end
    end

    it "must return a pagination style result" do
      @charges[:items].wont_be_nil
      @charges[:items].must_be_instance_of Array
      @charges[:pages].wont_be_nil
      @charges[:pages].must_be_instance_of Hash
    end

  end

end