require_relative 'base'

module Handlers
  class Relations < Base
    def affect_relation_values!
      relation_keys = upper(:@@relation_keys) || {}
      {}.merge(@params).each_key do |key|
        @params["#{key}_id".to_sym] = @params[key.to_sym].id if relation_keys.include?(key)
      end
    end
  end
end
