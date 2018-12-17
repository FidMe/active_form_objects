require 'active_support'
require 'active_support/core_ext/hash/indifferent_access'

module Dsl
  module Attributes
    extend ActiveSupport::Concern

    @@attributes = {}
    @@overrided_params = {}
    @@default_params = {}
    @@preparers = {}

    def attrs_only(params)
      attributes.slice(*params)
    end

    def attributes
      instance_values.with_indifferent_access.symbolize_keys
    end

    included do
      attr_accessor :params

      def self.attributes(*params)
        @@attributes[name] = (@@attributes[name] || []) + params
        attr_accessor(*params)
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

      def self.prepare(*params)
        method_to_call = params.last[:with]
        @@preparers[name] = (@@preparers[name] || []) + [{
          key: params.first,
          method_to_call: method_to_call
        }]
      end
    end
  end
end
