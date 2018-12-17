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
      polymorph_instance = form_class.new(@params_to_send, @resource.try(@polymorph[:key])).save!
      @params["#{@polymorph[:key]}_id"] = polymorph_instance.id
      @params["#{@polymorph[:key]}_type"] = polymorph_instance.class.name
      @params.delete(@polymorph[:key])
    end

    def form_class
      @polymorph[:types][
        @resource.try("#{@polymorph[:key]}_type") || clean_params.try(:to_sym)
      ]
    end

    def clean_params
      @params_to_send.delete(:type)
    end
  end
end
