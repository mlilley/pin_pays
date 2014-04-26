module PinPays
  class Cards < Api
    PATH = '/cards'

    class << self

      # Create a card
      #   card - hash of card details
      def create(card)
        api_response(api_post(PATH, card))
      end

    end

  end
end