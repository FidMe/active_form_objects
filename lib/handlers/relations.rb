require_relative 'base'

module Handlers
  class Relations < Base
    def affect_relation_values!
      relation_keys = upper(:@@relation_keys) || {}
      {}.merge(@params).each_key do |key|
        if relation_keys.include?(key.to_sym)
          raise_error("relation named :#{key} must be an ActiveRecord instance not a #{@params[key].class}. Check the params you sent to this form.") unless @params[key].respond_to?(:id)

          @params["#{key}_id"] = @params[key].id
        end
      end
    end
  end
end
