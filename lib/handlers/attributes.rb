require 'active_support/core_ext/hash/reverse_merge'
require_relative 'base'
require_relative 'relations'
require_relative 'delegates'

module Handlers
  class Attributes < Base
    def handle
      start_with_default_params!
      affect_prepared_values!
      remap_attributes!
      merge_with_resource_attributes!
      affect_relation_values!
      merge_overrided_params!
      slice_unauthorized_attributes!
    end

    # DSL method : set_default
    def start_with_default_params!
      default_params = upper(:@@default_params) || {}
      @params.reverse_merge!(default_params)
    end

    # DSL method : prepare
    def affect_prepared_values!
      (upper(:@@preparers) || []).each do |preparer|
        @params[preparer[:key]] = preparer[:lambda].try(:call, @params[preparer[:key]])
      end
    end

    # DSL method : remap
    def remap_attributes!
      (upper(:@@remaped_params) || []).each do |remaped|
        @params[remaped[:to]] = @raw_params[remaped[:key].to_s]
      end
    end

    def merge_with_resource_attributes!
      return unless @resource.respond_to?(:attributes)
      @params.reverse_merge!(@resource.attributes.symbolize_keys)
    end

    # DSL method : ensure_value
    def merge_overrided_params!
      overrided_params = upper(:@@overrided_params) || {}
      @params.merge!(overrided_params)
    end

    # DSL method : relation
    def affect_relation_values!
      Relations.new(@klass).affect_relation_values!
    end

    # DSL method : attributes
    def slice_unauthorized_attributes!
      authorized_attributes = upper(:@@attributes) || {}
      @params.slice!(*authorized_attributes)
    end
  end
end
