require 'minitest/autorun'
require 'active_form_objects'
require 'active_support'

require_relative '../helper'

class Dsl::AttributesTest < ActiveSupport::TestCase
  test 'can declare and filter params' do
    form = AttributesForm.new(id: '123', coucou: 'lol')
    assert_equal '123', form.params[:id]
    assert_nil form.params[:coucou]
  end

  test 'raises relevant errors if attributes is not correctly declared' do
    error = nil
    begin
      class AttributesBadlyDeclaredForm < ActiveFormObjects::Base
        attributes
      end
    rescue => e
      error = e.message
    end

    assert error.include?('must not be empty')
  end

  test 'set_default allows to set default value to a param' do
    class ExampleForm < ActiveFormObjects::Base; set_default value: 'coucou', to: :entity; end
    form = ExampleForm.new({})

    assert_equal 'coucou', form.entity
  end

  test 'remap remaps an attribute to another' do
    class ExampleForm < ActiveFormObjects::Base
      remap :offer_id, to: :entity_id
    end

    form = ExampleForm.new(offer_id: 'coucou')
    assert_equal 'coucou', form.params[:entity_id]
  end

  test 'remap with nil value does not create param' do
    class ExampleForm < ActiveFormObjects::Base
      remap :offer_id, to: :entity_id
    end

    form = ExampleForm.new({})
    assert_not form.params.key?(:entity_id)
    form = ExampleForm.new(offer_id: 'lol')
    assert form.params.key?(:entity_id)
  end

  test 'remap with overrided value is left intact' do
    class ExampleForm < ActiveFormObjects::Base
      remap :offer_id, to: :entity_id
    end

    form = ExampleForm.new(entity_id: 'lol', offer_id: 'hihi')
    assert_equal 'lol', form.params[:entity_id]
  end

  test 'set_default can handle errors properly' do
    error = nil
    begin
      class ExampleForm < ActiveFormObjects::Base; set_default valu: 'cocou'; end
    rescue => e
      error = e.message
    end

    assert error.include?('must be declared')
  end

  class AttributesForm < ActiveFormObjects::Base
    attributes :id
  end
end
