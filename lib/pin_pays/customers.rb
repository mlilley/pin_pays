module PinPays
  class Customers < Api
    PATH = '/customers'

    class << self

      # Creates a customer
      #   card - either a card token (string), or a hash of card details
      def create(email, card)
        options = { email: email }
        options = options.merge(card.is_a?(String) ? { card_token: card } : { card: card })
        api_response(api_post(PATH, options))
      end

      # List all customers
      # Page - the page number to return (optional)
      def list(page = nil)
        options = (page.nil? ? nil : { page: page })
        api_paginated_response(api_get(PATH, options))
      end

      # Retrieve details of a specific customer
      def show(customer_token)
        api_response(api_get("#{PATH}/#{customer_token}"))
      end

      # Update a customer
      # Options - a hash specifying one or more of: email, card_token, or card (hash)
      def update(customer_token, options)
        api_response(api_put("#{PATH}/#{customer_token}", options))
      end

      # List all charges for a customer
      # Page - the page number to return (optional)
      def charges(customer_token, page = nil)
        options = (page.nil? ? nil : { page: page })
        api_paginated_response(api_get("#{PATH}/#{customer_token}/charges", options))
      end

    end

  end
end