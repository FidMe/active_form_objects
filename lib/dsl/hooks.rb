require 'active_support'
require 'active_model'

module Dsl
  module Hooks
    extend ActiveSupport::Concern

    @@before_save = {}
    @@after_save = {}

    class_methods do
      def before_save(*params, &block)
        hooks = block.present? ? [block] : params
        @@before_save[name] = (@@before_save[name] || []) + hooks
      end

      def after_save(*params, &block)
        hooks = block.present? ? [block] : params
        @@after_save[name] = (@@after_save[name] || []) + hooks
      end
    end
  end
end
