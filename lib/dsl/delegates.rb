require 'active_support'

module Dsl
  module Delegates
    extend ActiveSupport::Concern

    @@delegators = {}
    included do
      def self.delegate(*params)
        delegator = params.last[:to]
        params.pop

        if delegator.is_a?(Hash)
          delegator[:attributes] = params
          @@delegators[name] = (@@delegators[name] || []) << delegator
        else
          send(:attributes, *params)
          define_method("#{delegator}_params") do
            attrs_only(params)
          end
        end
      end
    end
  end
end
