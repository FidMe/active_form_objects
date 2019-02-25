require 'active_support'

module Dsl
  module Debug
    extend ActiveSupport::Concern

    @@debug = {}
    included do
      def self.debug
        @@debug[name] = true
      end
    end
  end
end
