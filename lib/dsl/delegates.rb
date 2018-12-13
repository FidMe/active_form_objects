require 'active_support'

module Dsl
  module Delegates
    extend ActiveSupport::Concern

    @@delegators = {}

    included do
      def self.delegate(*params)
        delegator = params.last[:to].merge(attributes: params)
        params.pop

        @@delegators[name] = (@@delegators[name] || []) << delegator
      end
    end
  end
end
