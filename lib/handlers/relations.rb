require_relative 'base'

module Handlers
  class Relations < Base
    def affect_relation_values!
      relation_keys = upper(:@@relation_keys) || {}
      {}.merge(@params).each_key do |key|
        @params["#{key}_id"] = @params[key].id if relation_keys.include?(key.to_sym)
      end
    end
  end
end
