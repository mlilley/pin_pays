module PinPays
  class Refunds < Api
    PATH = '/charges'

    class << self

      # Create a refund
      # Amount - amount of charge to refund (optional)
      def create(charge_token, amount = nil)
        options = (amount.nil? ? nil : { amount: amount })
        api_response(api_post("#{PATH}/#{charge_token}/refunds", options))
      end

      # List all refunds for a charge
      # Note: does not return the usual paginated response.  Instead returns only an array.
      def list(charge_token)
        api_response(api_get("#{PATH}/#{charge_token}/refunds"))
      end

    end

  end
end