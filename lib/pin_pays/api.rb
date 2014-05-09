module PinPays
  class Api
    LIVE_URI = 'https://api.pin.net.au/1'
    TEST_URI = 'https://test-api.pin.net.au/1'

    include HTTParty

    class << self

      def setup(config)
        base_uri(config.mode == :live ? LIVE_URI : TEST_URI)
        @@auth = { username: config.key, password: '' }
      end

      protected

      def api_get(path, query = nil)
        get(path, query: query, basic_auth: @@auth)
      end

      def api_post(path, body = nil)
        post(path, body: body, basic_auth: @@auth)
      end

      def api_put(path, body = nil)
        put(path, body: body, basic_auth: @@auth)
      end

      def api_response(response)
        raise ApiError.new(response.code, symbolize_keys(response.parsed_response)) unless response.code == 200 || response.code == 201
        symbolize_keys(response.parsed_response['response'])
      end

      def api_paginated_response(response)
        raise ApiError.new(response.code, sybolize_keys(response.parsed_response)) unless response.code == 200 || response.code == 201
        { items: symbolize_keys(response.parsed_response['response']), pages: symbolize_keys(response.parsed_response['pagination']) }
      end

      def symbolize_keys(o)
        return o.reduce({}) {|memo, (k, v)| memo.tap { |m| m[k.to_sym] = symbolize_keys(v) }} if o.is_a?(Hash)
        return o.reduce([]) {|memo, v| memo << symbolize_keys(v); memo } if o.is_a?(Array)
        o
      end

    end

  end
end