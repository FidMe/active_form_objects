require 'active_support'
require 'active_model'

module Relations
  extend ActiveSupport::Concern

  @@relation_keys = {}

  class RelationValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors.add(attribute, "#{attribute} or #{attribute}_id is required") unless record.try(attribute).present? || record.try("#{attribute}_id".to_sym).present?
    end
  end

  def affect_relation_values(params)
    @relation_keys = @@relation_keys[self.class.name] || []
    params.keys.each do |key|
      params["#{key}_id".to_sym] = params[key.to_sym].id if @relation_keys.include?(key)
    end

    params
  end

  class_methods do
    def relations(*params)
      validates *params, relation: true

      params.each do |param|
        relation_key = "#{param}_id".to_sym
        send(:attributes, param, relation_key)
        @@relation_keys[name] = (@@relation_keys[name] || []) + [param]
      end
    end
  end
end
