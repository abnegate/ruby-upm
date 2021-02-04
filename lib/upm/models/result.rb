module Upm
  class Result
    attr_reader :success, :data
    attr_accessor :message

    # @param success  [Boolean]
    # @param message  [String, nil]
    # @param data     [Object, nil]
    def initialize(success, message = nil, data = nil)
      @success = success
      @message = message
      @data = data
    end

    # @param message  [String, nil]
    # @param data     [Object, nil]
    def self.success(message = nil, data = nil)
      Result.new(true, message, data)
    end

    # @param message  [String, nil]
    # @param data     [Object, nil]
    def self.failure(message = nil, data = nil)
      Result.new(false, message, data)
    end
  end
end
