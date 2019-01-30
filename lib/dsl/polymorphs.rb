require 'active_support'
require 'active_model'

module Dsl
  module Polymorphs
    extend ActiveSupport::Concern

    @@polymorphic_keys = {}

    class PolymorphValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, data)
        return unless record.try(attribute).try(:id).nil? &&
                      record.try("#{attribute}_id".to_sym).nil? &&
                      !options[:keys].include?(data['type'].try(:to_sym))
        record.errors.add(attribute, 'type must be included in the list')
      end
    end

    class_methods do
      # Allows to declare a polymorphic relationship
      #
      # Params:
      # +key+:: the corresponding key in the params hash
      # +possible_types+:: A hash that follows the below format
      #
      # polymorph(:content, {
      #   foo: Bar
      # })
      #
      # Int the above example the possible_types hash :
      #   scannable => key
      #   Scannable => model class
      #
      def polymorph(key, possible_types)
        validates(key, polymorph: { keys: possible_types.keys })

        @@polymorphic_keys[name] ||= []
        @@polymorphic_keys[name] << {
          key: key,
          types: possible_types
        }
        send(:attributes, key, "#{key}_id")
      end
    end
  end
end

