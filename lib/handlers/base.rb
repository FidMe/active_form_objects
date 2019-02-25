module Handlers
  class Base
    def initialize(klass)
      @klass = klass
      @raw_params = @klass.instance_variable_get(:@raw_params)
      @params = @klass.instance_variable_get(:@params)
      @resource = @klass.instance_variable_get(:@resource)
    end

    def self.handle(*params)
      new(*params).handle
    end

    def upper(var)
      @klass.class.class_variable_get(var)[@klass.class.name]
    end

    def raise_error(string)
      raise ActiveFormObjects::HandlerError.new("[#{@klass.class.name}] #{string}")
    end
  end
end

module ActiveFormObjects
  class HandlerError < RuntimeError
  end
end
