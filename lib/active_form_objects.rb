require 'active_support'
require 'active_model'
require 'active_support/core_ext/object/instance_variables'
require 'active_support/core_ext/hash/indifferent_access'
require_relative 'concerns/relations'
require_relative 'concerns/savings'

module ActiveFormObjects
  class Base
    include ActiveModel::Model
    include Relations
    include Savings

    @@authorized_params = {}
    @@overrided_params = {}
    @@default_params = {}
    @@preparers = {}
    @@resource = {}

    attr_reader :resource

    def self.resource(resource = nil, &block)
      bloc_to_call = block || proc { resource }
      @@resource[name] = bloc_to_call
    end

    def self.prepare(*params)
      method_to_call = params.last[:with]
      @@preparers[name] = (@@preparers[name] || []) + [{
        key: params.first,
        method_to_call: method_to_call
      }]
    end

    def self.attributes(*params)
      @@authorized_params[name] = (@@authorized_params[name] || []) + params
      send(:attr_accessor, *params)
    end

    def self.delegate(*params)
      delegator = params.last
      params.pop
      send(:attributes, *params)
      define_method("#{delegator[:to]}_params") do
        attrs_only(params)
      end
    end

    def self.set_default(params)
      [params[:to]].flatten.each do |param|
        @@default_params[name] ||= {}
        @@default_params[name][param] = params[:value]
      end
      send(:attributes, *params[:to])
    end

    def self.ensure_value(param, value)
      @@overrided_params[name] ||= {}
      @@overrided_params[name][param] = value

      send(:attributes, param)
    end

    def initialize(params, resource = nil)
      @resource = resource || @@resource[self.class.name].try(:call, params).try(:new)
      set_associated_forms
      params = affect_relation_values(params)
      resource_params(params || {})

      params_with_resource_attrs = @resource.respond_to?(:attributes) ? @resource.attributes.symbolize_keys.slice(*@authorized_params).merge(@params) : @params
      params_with_preprared_value = affect_prepared_values(params_with_resource_attrs)
      super(params_with_preprared_value)
    end

    def affect_prepared_values(params)
      (@@preparers[self.class.name] || []).each do |preparer|
        params[preparer[:key]] = params[preparer[:key]].try(preparer[:method_to_call])
      end
      params
    end

    def resource_params(params)
      @default_params = @@default_params[self.class.name] || {}
      @overrided_params = @@overrided_params[self.class.name] || {}
      @authorized_params = @@authorized_params[self.class.name] || {}
      @params = @default_params.merge(params.to_h.symbolize_keys).merge(@overrided_params).slice(*@authorized_params)
    end

    def attrs_only(params)
      attributes.slice(*params)
    end

    def attributes
      instance_values.with_indifferent_access.symbolize_keys
    end
  end
end
