module Handlers
  class Base
    def initialize(klass)
      @klass = klass
      @raw_params = @klass.instance_variable_get(:@raw_params)
      @params = @klass.instance_variable_get(:@params)
      @resource = @klass.instance_variable_get(:@resource)
    end

    def self.handle(klass)
      new(klass).handle
    end

    def upper(var)
      @klass.class.class_variable_get(var)[@klass.class.name]
    end

    def raise_error(string)
      raise ActiveFormObjects::Error.new("[#{@klass.class.name}] #{string}")
    end
  end
end

module ActiveFormObjects
  class Error < RuntimeError
  end
end
