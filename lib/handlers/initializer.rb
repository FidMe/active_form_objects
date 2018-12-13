module Handlers
  class Initializer
    def self.handle(klass)
      params = klass.instance_variable_get(:@params)
      klass.instance_variable_set('@raw_params', {}.merge(params).freeze)
    end
  end
end
