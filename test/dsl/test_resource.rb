require 'minitest/autorun'
require 'active_form_objects'
require 'active_support'

require_relative '../helper'


USER_CLASS = Struct.new(:id) do
  def attributes
    { id: id }
  end

  def self.all;end
end

class Dsl::ResourceTest < ActiveSupport::TestCase
  test 'can declare resource' do
    form = ResourceForm.new({})
    assert form.resource.is_a?(USER_CLASS)
  end

  test 'can pass resource' do
    form = ResourceForm.new({}, ResourceForm.new({}))
    assert form.resource.is_a? ResourceForm
  end

  class ResourceForm < ActiveFormObjects::Base
    resource USER_CLASS
  end
end
