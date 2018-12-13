require 'active_model'

require_relative 'dsl/relations'
require_relative 'dsl/attributes'
require_relative 'dsl/delegates'
require_relative 'dsl/savings'
require_relative 'dsl/resource'
require_relative 'dsl/polymorphs'

require_relative 'handlers/initializer'
require_relative 'handlers/relations'
require_relative 'handlers/resource'
require_relative 'handlers/attributes'

module ActiveFormObjects
  class Base
    include ActiveModel::Model

    include Dsl::Resource
    include Dsl::Attributes
    include Dsl::Relations
    include Dsl::Polymorphs
    include Dsl::Delegates
    include Dsl::Savings

    def initialize(params, resource = nil)
      @params = params
      @resource = resource

      Handlers::Initializer.handle(self)
      Handlers::Resource.handle(self)
      Handlers::Attributes.handle(self)
      super(@params)
    end
  end
end
