require 'active_support'

module Dsl
  module Associates
    extend ActiveSupport::Concern

    @@associated_forms = {}

    class_methods do
      def associated(key, form, params = nil)
        @@associated_forms[name] ||= []
        @@associated_forms[name] << { name: key, form: form, params: params }

        set_default value: {}, to: key
      end
    end
  end
end
