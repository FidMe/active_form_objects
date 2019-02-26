require_relative 'base'

module Handlers
  class Resource < Base
    def handle
      class_resource = upper(:@@resource)
      @resource ||= class_resource.try(:call, @params).try(:new)

      attempt_resource_autoset

      @klass.instance_variable_set(:@resource, @resource)
    end

    def attempt_resource_autoset
      class_name = @klass.class.name.split('Form')[0].constantize if @klass.class.name.include?('Form')
      @resource ||= class_name.instance_of?(Class) ? class_name.new : nil
    rescue
    end
  end
end
