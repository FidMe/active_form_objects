require 'active_support'
require 'active_model'

module Dsl
  module Relations
    extend ActiveSupport::Concern

    @@relation_keys = {}

    class RelationValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, _)
        record.errors.add(attribute, "#{attribute} or #{attribute}_id is required") unless record.try(attribute).present? || record.try("#{attribute}_id".to_sym).present?
      end
    end

    class_methods do
      # Allows to receive a relation as an input params.
      # Relation can then be received either as :
      #   - relation_id => The key to the corresponding relation
      #   - relation    => An instance of the object
      #
      # Params:
      # +params+:: the list of relations to declare
      #
      # Example :
      #   relations(:entity, :user)
      #
      def relations(*params)
        validates(*params, relation: true)

        params.each do |param|
          relation_key = "#{param}_id".to_sym
          send(:attributes, param, relation_key)
          @@relation_keys[name] = (@@relation_keys[name] || []) + [param]
        end
      end
    end
  end
end
