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

  class AttributesForm < ActiveFormObjects::Base
    attributes :id
  end
end
