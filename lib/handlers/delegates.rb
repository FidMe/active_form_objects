require_relative 'base'

module Handlers
  class Delegates < Base
    def handle
      delegates = upper :@@delegators
      (delegates || []).each do |delegate|
        Delegate.new(@klass, delegate).handle
      end
    end
  end

  class Delegate < Base
    def initialize(klass, delegate)
      @delegate = delegate

      @form = @delegate[:form]
      @foreign_key = @delegate[:foreign_key]
      @relation = @delegate[:relation]
      @attributes = @delegate[:attributes]

      super(klass)
    end

    def handle
      @attributes = @raw_params.slice(*@attributes).merge({
        @foreign_key => @resource.id
      })

      @form.new(@attributes, @resource.send(@relation)).save!
    end
  end
end
