require 'active_model'
require 'active_support/core_ext/hash/indifferent_access'

require_relative 'dsl/debug'
require_relative 'dsl/relations'
require_relative 'dsl/attributes'
require_relative 'dsl/delegates'
require_relative 'dsl/savings'
require_relative 'dsl/resource'
require_relative 'dsl/polymorphs'
require_relative 'dsl/scopes'

require_relative 'handlers/base'
require_relative 'handlers/initializer'
require_relative 'handlers/debug'
require_relative 'handlers/inheritance'
require_relative 'handlers/relations'
require_relative 'handlers/resource'
require_relative 'handlers/attributes'

module ActiveFormObjects
  class Base
    include ActiveModel::Model

    include Dsl::Debug
    include Dsl::Resource
    include Dsl::Attributes
    include Dsl::Relations
    include Dsl::Polymorphs
    include Dsl::Delegates
    include Dsl::Savings
    include Dsl::Scopes

    def self.inherited(subclass)
      Handlers::Inheritance.handle(subclass, self)
    end

    def initialize(params, resource = nil)
      raise ActiveFormObjects::HandlerError, "[#{self.class.name}] params were not correclty declared" unless params.is_a?(Hash)

      @params = params.with_indifferent_access
      @resource = resource

      Handlers::Initializer.handle(self)
      Handlers::Resource.handle(self)
      Handlers::Attributes.handle(self)
      Handlers::Debug.handle(self)
      super(@params)
    end
  end
end
