require 'active_support'

module Dsl
  module Resource
    extend ActiveSupport::Concern

    @@resource = {}

    included do
      attr_reader :resource

      def self.resource(resource = nil, &block)
        raise ActiveFormObjects::DslError.new("[#{self.name}] resource has been incorrectly declared") if (resource.nil? && block.nil?) || (block.nil? && !resource.respond_to?(:all))

        bloc_to_call = block || proc { resource }
        @@resource[name] = bloc_to_call
      end
    end
  end
end
