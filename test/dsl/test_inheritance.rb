require 'minitest/autorun'
require 'active_form_objects'
require 'active_support'

require_relative '../helper'

RESOURCE = Struct.new(:id) do
  def self.all
  end
end

OTHER_RESOURCE = Struct.new(:coucou) do
  def self.all
  end
end

class Dsl::InheritanceTest < ActiveSupport::TestCase
  test 'dsl declared in parent classes can be used in child classes' do
    form = ChildForm.new(
      id: '123',
      lol_id: 'salut',
      coucou_id: 'lol',
      first_name: 'Michael',
      last_name: 'Villeneuve'
    )

    assert_nil form.params[:coucou]
    assert_equal '123', form.params[:id]
    assert_equal 'salut', form.params[:lol_id]
    assert_equal 'Michael', form.profile_params[:first_name]
    assert_equal 'Villeneuve', form.other_profile_params[:last_name]
  end

  test 'overrided dsls are prevalent' do
    form = ChildForm.new({})
    assert_equal OTHER_RESOURCE.new, form.resource
  end

  class ParentForm < ActiveFormObjects::Base
    delegate :first_name, :last_name, to: :profile
    attributes :id
    resource RESOURCE
    relations :coucou
  end

  class ChildForm < ParentForm
    delegate :last_name, to: :other_profile
    attributes :lol
    resource OTHER_RESOURCE
    relations :lol
  end
end
