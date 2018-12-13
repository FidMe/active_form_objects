require 'active_support'
require 'active_model'

module Dsl
  module Polymorphs
    extend ActiveSupport::Concern

    @@polymorphic_keys = {}

    class_methods do
      # Allows to declare a polymorphic relationship
      #
      # Params:
      # +key+:: the corresponding key in the params hash
      # +possible_types+:: A hash that follows the below format
      #
      # polymorph(:content, :program_id, {
      #   foo: Bar
      # })
      #
      # Int the above example the possible_types hash :
      #   scannable => key
      #   Scannable => model class
      #
      def polymorph(key, possible_types)
        @@polymorphic_keys[name] ||= []
        @@polymorphic_keys[name] << {
          key: key,
          types: possible_types
        }
        send(:attributes, key)
      end
    end
  end
end
