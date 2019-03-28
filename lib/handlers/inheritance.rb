require_relative 'base'

module Handlers
  class Inheritance < Base
    def initialize(subclass, klass)
      @subclass = subclass
      @klass = klass
    end

    def handle
      return nil if regular_inheritance?

      @klass.class_variables.each do |var_name|
        dsl_values = @subclass.class_variable_get(var_name)

        dsl_values[@subclass.name] = dsl_values[@klass.name].dup
      end
    end

    private

    def regular_inheritance?
      @klass == ActiveFormObjects::Base
    end
  end
end
