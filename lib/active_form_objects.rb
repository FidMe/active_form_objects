require 'active_model'
require 'active_support/core_ext/hash/indifferent_access'


require_relative 'dsl/relations'
require_relative 'dsl/attributes'
require_relative 'dsl/delegates'
require_relative 'dsl/savings'
require_relative 'dsl/resource'
require_relative 'dsl/associates'
require_relative 'dsl/polymorphs'

require_relative 'handlers/initializer'
require_relative 'handlers/inheritance'
require_relative 'handlers/relations'
require_relative 'handlers/resource'
require_relative 'handlers/attributes'
require_relative 'handlers/associates'

module ActiveFormObjects
  class Base
    include ActiveModel::Model

    include Dsl::Resource
    include Dsl::Attributes
    include Dsl::Relations
    include Dsl::Polymorphs
    include Dsl::Delegates
    include Dsl::Associates
    include Dsl::Savings

    def self.inherited(subclass)
      Handlers::Inheritance.handle(subclass, self)
    end

    def initialize(params, resource = nil)
      @params = params.with_indifferent_access
      @resource = resource

      Handlers::Initializer.handle(self)
      Handlers::Associates.handle(self)
      Handlers::Resource.handle(self)
      Handlers::Attributes.handle(self)
      super(@params)
    end
  end
end
