require_relative 'base'

module Handlers
  class Polymorphs < Base
    def handle
      polymorphs = upper :@@polymorphic_keys
      (polymorphs || []).each do |polymorph|
        Polymorph.new(@klass, polymorph).handle
      end
    end
  end

  class Polymorph < Base
    # Handle either the retrieving of the associated relation
    # or
    # the creation of the resource based on this possible input and the params
    #
    # Params:
    # +klass+:: ActiveFormObject::Base instance
    # +polymorph+:: The param specified in the dsl, example :
    #  {
    #      key: :content,
    #      foreign_key: :program_id,
    #      types: {
    #        polymorph: Dsl::PolymorphsTest::PolymorphForeignForm
    #      }
    #    }
    #
    def initialize(klass, polymorph)
      @polymorph = polymorph

      super(klass)
    end

    def handle
      @params_to_send = @params[@polymorph[:key]] || {}
      form = form_class

      raise_error("The form resolved with key '#{@type}' seems to be nil. Check your polymorphic relation key and the associated forms.") if form.nil?

      polymorph_instance = form.new(@params_to_send, @resource.try(@polymorph[:key])).save!

      @params["#{@polymorph[:key]}_id"] = polymorph_instance.id
      @params["#{@polymorph[:key]}_type"] = polymorph_instance.class.name
      @params.delete(@polymorph[:key])
    end

    def form_class
      @type = @resource.try(@polymorph[:key]).try(:type) || @params_to_send['type']
      raise_error("No 'type' method or 'type‘ key found in params for '#{@polymorph[:key]}' polymorphic relation") if @type.nil?

      @params_to_send.delete(:type)
      @polymorph[:types][@type.try(:to_sym)]
    end
  end
end
