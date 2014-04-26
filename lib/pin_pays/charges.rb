module PinPays
  class Charges < Api
    PATH = '/charges'

    class << self

      # Create a charge for a customer or card
      # Options (hash) containing:
      #   (mandatory)         email, description, amount, and remote_ip
      #   (mandatory, one of) customer_token, card_token, or card (a hash of card details)
      #   (optional)          currency, capture
      def create(options)
        api_response(api_post(PATH, options))
      end

      # Captures a previously authorized charge
      def capture(charge_token)
        api_response(api_put("#{PATH}/#{charge_token}/capture"))
      end

      # Lists all charges
      # Page - the page number to return (optional)
      def list(page = nil)
        options = (page.nil? ? nil : { page: page })
        api_paginated_response(api_get(PATH, options))
      end

      # Search for charges that match one or more criteria
      # Criteria - a hash of search criteria
      def search(criteria)
        api_paginated_response(api_get("#{PATH}/search", criteria))
      end

      # Retrieve details of a specific charge
      def show(charge_token)
        api_response(api_get("#{PATH}/#{charge_token}"))
      end

    end

  end
end