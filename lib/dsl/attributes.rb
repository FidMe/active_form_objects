require 'active_support'
require 'active_support/core_ext/hash/indifferent_access'
require_relative 'errors'

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
        raise ActiveFormObjects::DslError.new("[#{self.name}] attributes must not be empty") if params.empty?

        @@attributes[name] = (@@attributes[name] || []) + params
        attr_accessor(*params)
      end

      def self.set_default(params)
        raise ActiveFormObjects::DslError.new("[#{self.name}] set_default must be declared like { value: 'the default', to: :the_attribute }") if params[:to].nil? || params[:value].nil?

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
        raise ActiveFormObjects::DslError.new("[#{self.name}] prepare takes a lambda as second argument, not a #{params.last.class.name}") if !params.last.respond_to?(:call)

        lambda_to_call = params.last
        @@preparers[name] = (@@preparers[name] || []) + [{
          key: params.first,
          lambda: lambda_to_call
        }]
      end
    end
  end
end
