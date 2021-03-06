require 'active_support'
require 'active_record'

require_relative 'base'
require_relative 'polymorphs'
require_relative 'delegates'
require_relative 'hooks'

module Handlers
  class Savings < Base
    def save!(&block)
      ActiveRecord::Base.transaction do
        @klass.validate!
        after_validations_hooks!
        block ? save_with_block!(block) : save_without_block!
        after_save_hooks!
      end
      after_commit_hooks!
      @resource
    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.add(e.record.class.name, '')
      raise ActiveRecord::RecordInvalid.new(e.record)
    end

    def after_save_hooks!
      Delegates.handle(@klass)
      AfterSaveHooks.handle(@klass)
    end

    def save_with_block!(block)
      @klass.instance_eval(&block)
      @resource = @klass.instance_variable_get(:@resource)
      @resource
    end

    def save_without_block!
      @resource.update!(@params)
    end

    def after_validations_hooks!
      AfterValidationsHooks.handle(@klass)
      Polymorphs.handle(@klass)
    end

    def after_commit_hooks!
      AfterCommitHooks.handle(@klass)
    end
  end
end
