require_relative 'base'

module Handlers
  class BeforeSaveHooks < Base
    def handle
      handle_hooks('before_save')
    end

    def handle_hooks(hook_name)
      (upper("@@#{hook_name}") || []).each do |method_or_block|
        handle_single(method_or_block)
      end
    end

    def handle_single(method_or_block)
      raise_error('a hook seems to be nil') if method_or_block.nil?

      method_or_block.respond_to?(:call) ? handle_block(method_or_block) : handle_method(method_or_block)
    end

    def handle_block(block)
      @klass.instance_eval(&block)
    end

    def handle_method(method)
      raise_error("could not find hook method named #{method}") unless @klass.respond_to?(method)
      @klass.send(method)
    end
  end

  class AfterSaveHooks < BeforeSaveHooks
    def handle
      handle_hooks('after_save')
    end
  end

  class AfterValidationsHooks < BeforeSaveHooks
    def handle
      handle_hooks('after_validation')
    end
  end
end
