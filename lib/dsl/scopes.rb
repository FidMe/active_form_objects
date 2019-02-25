require 'active_support'
require 'method_source'

module Dsl
  module Scopes
    extend ActiveSupport::Concern

    @@scopes = {}

    included do
      def self.scope(*params, &block)
        raise(ActiveFormObjects::DslError, "[#{name}] scope must be a bloc") if block.nil? || !block.respond_to?(:call)

        params.each do |param|
          block_content = block.source.lines.to_a[1..-1].join.gsub(/end\n$/, ' ')
          eval("class ::#{name}Scope#{param.capitalize} < #{name} ; #{block_content}; end")
        end
      end

      def self.new(params, resource = nil, options = {})
        if options[:scope].present?
          class_to_call = "::#{name}Scope#{options[:scope].capitalize}".constantize rescue raise(ActiveFormObjects::DslError, "[#{name}] No scope named #{options[:scope]} found")
          return class_to_call.new(params, resource)
        end

        super(params, resource)
      end
    end
  end
end
