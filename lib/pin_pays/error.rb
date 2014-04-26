module PinPays
  class ApiError < StandardError

    attr_accessor :status, :error, :error_description, :charge_token, :messages, :raw_response

    def initialize(status, response)
      @status            = status

      @error             = response['error']
      @error_description = response['error_description']
      @charge_token      = response['charge_token']
      @messages          = response['messages']

      @raw_response      = response

      #puts "ApiError"
      #puts "  #{@status} #{@error} #{@error_description}"
    end

    def to_s
      "#{@error}"
    end

  end
end