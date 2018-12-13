require_relative 'base'

module Handlers
  class Resource < Base
    def handle
      class_resource = upper(:@@resource)
      @resource ||= class_resource.try(:call, @params).try(:new)

      @klass.instance_variable_set(:@resource, @resource)
    end
  end
end
