require 'minitest/autorun'
require 'active_form_objects'
require 'active_support'

require_relative '../helper'


RESOURCE = Struct.new(:id) do
  def attributes
    { id: id }
  end

  def self.all;end
end

POLYMORH_RELATION = Struct.new(:id, :parent_id) do
  def attributes
    { id: id }
  end

  def self.all;end
end

class Dsl::PolymorphsTest < ActiveSupport::TestCase
  test 'can create polymorph relation' do
    polymorph_relation_instance = POLYMORH_RELATION.new('1234')
    POLYMORH_RELATION
      .any_instance
      .expects(:update!)
      .with('id' => '1234')
      .once

    POLYMORH_RELATION
      .expects(:new)
      .once
      .returns(polymorph_relation_instance)

    relation_to_return = PolymorphForeignForm.new({ id: '1234' }, nil)

    PolymorphForeignForm
      .expects(:new)
      .with({ 'id' => '1234' }, nil)
      .once
      .returns(relation_to_return)

    RESOURCE
      .any_instance
      .expects(:update!)
      .with('content_id' => '1234', 'content_type' => POLYMORH_RELATION.name)
      .once

    form = PolymorphForm.new({
      content: {
        type: 'polymorph',
        id: '1234'
      }
    }, RESOURCE.new)
    form.save!
  end

  test 'polymorph relation raises validation error' do
    form = PolymorphForm.new({
      content: {
        id: '1234'
      }
    }, RESOURCE.new)

    exception = assert_raises(Exception) { form.save! }
    assert_equal 'Validation failed: Content type must be included in the list', exception.message
  end

  class PolymorphForeignForm < ActiveFormObjects::Base
    resource POLYMORH_RELATION
    attributes :id
  end

  class PolymorphForm < ActiveFormObjects::Base
    polymorph :content, polymorph: PolymorphForeignForm
  end
end
