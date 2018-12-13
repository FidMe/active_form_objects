require 'active_support'

module Dsl
  module Resource
    extend ActiveSupport::Concern

    @@resource = {}

    included do
      attr_reader :resource
      
      def self.resource(resource = nil, &block)
        bloc_to_call = block || proc { resource }
        @@resource[name] = bloc_to_call
      end
    end
  end
end
