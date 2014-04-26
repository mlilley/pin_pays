module PinPays
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
    Api.setup(configuration)
  end

  class Configuration
    attr_accessor :key
    attr_accessor :mode

    def initialize
      @key  = nil
      @mode = :test
    end
  end
end