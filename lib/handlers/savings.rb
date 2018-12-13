require 'active_support'
require 'active_record'

require_relative 'base'
require_relative 'polymorphs'
require_relative 'delegates'

module Handlers
  class Savings < Base
    def save!(&block)
      # ActiveRecord::Base.transaction do
        @klass.validate!

        before_save_hooks!
        block ? save_with_block!(block) : save_without_block!
        after_save_hooks!

        @resource
      # end
    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.add(e.record.class.name, '')
      raise ActiveRecord::RecordInvalid.new(e.record)
    end

    def after_save_hooks!
      Delegates.handle(@klass)
    end

    def save_with_block!(block)
      @klass.instance_eval(&block)
      @resource.try(:save!)
    end

    def save_without_block!
      @resource.update!(@params)
    end

    def before_save_hooks!
      Polymorphs.handle(@klass)
    end
  end
end
