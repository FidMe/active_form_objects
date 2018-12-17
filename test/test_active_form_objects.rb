require 'minitest/autorun'
require 'active_form_objects'
require 'active_support'

require_relative 'helper'

class BaseFormTest < ActiveSupport::TestCase
  setup do
    @UserClass = Struct.new(:id, :friend, :friend_id) do
      def attributes
        { id: id, friend_id: friend.id }
      end
    end
    @pierre = @UserClass.new('Pierre', nil)
    @paul = @UserClass.new('Paul', @pierre)
  end

  test 'ensure_value allows to set custom attributes on top of params' do
    class PostForm < ActiveFormObjects::Base
      ensure_value :published, true
    end
    form = PostForm.new(name: 'Coucou', siret: '1234', coucou: 'lol', published: false)

    assert_equal true, form.published
  end

  test 'attributes and delegate allow to declare authorized attrs' do
    class CategoryForm < ActiveFormObjects::Base; attributes :coucou; end
    form = CategoryForm.new(coucou: 'lol')

    assert_equal 'lol', form.coucou
  end

  test 'unauthorized attributes are removed from final params' do
    class CategoryForm < ActiveFormObjects::Base; attributes :coucou; end
    form = CategoryForm.new(coucou: 'lol', siret: '1234')

    assert_not form.respond_to?(:siret)
  end

  test 'heriting class has access to ActiveModel::Model' do
    class DelegatorForm < ActiveFormObjects::Base;end
    form = DelegatorForm.new(name: 'lol')

    assert form.respond_to?(:validate!)
  end

  test 'resource is accessible' do
    class DelegatorForm < ActiveFormObjects::Base;end
    form = DelegatorForm.new({ name: 'lol' }, 'lol')

    assert_equal 'lol', form.resource
  end

  test 'set_default allows to set default value to a param' do
    class ExampleForm < ActiveFormObjects::Base; set_default value: 'coucou', to: :entity; end
    form = ExampleForm.new({})

    assert_equal 'coucou', form.entity
  end

  test 'resource can call a block' do
    class TestModel; end
    class TestForm < ActiveFormObjects::Base
      resource do |_params|
        'BaseFormTest::TestModel'.constantize
      end
    end
    assert_instance_of TestModel, TestForm.new({}).resource
  end

  test 'relations allows relation attributes' do
    class TestForm < ActiveFormObjects::Base
      relations :user
    end

    form = TestForm.new(user: @paul)
    other_form = TestForm.new(user_id: @paul.id)
    assert_equal 'Paul', form.user.id
    assert_equal 'Paul', other_form.user_id
  end

  test 'relations validates either relation or relation_id' do
    class TestForm < ActiveFormObjects::Base
      relations :user
    end

    form = TestForm.new({})
    assert_not form.valid?
    assert form.errors.key?(:user), 'should have a user error key'
  end

  test 'relations are valid when params are empty if resource already has them' do
    class AnotherFriendShipForm < ActiveFormObjects::Base
      relations :friend
    end

    form = AnotherFriendShipForm.new({}, @paul)
    assert form.valid?
    assert_equal 'Pierre', form.friend_id
  end

  test 'relations keeps only resource from params on update' do
    class FriendShipChangeForm < ActiveFormObjects::Base
      relations :friend
    end

    @jacques = @UserClass.new('Jacques', nil)
    assert_equal @pierre, @paul.friend
    form = FriendShipChangeForm.new({ friend: @jacques }, @paul)

    assert form.valid?
    assert_equal @jacques, form.friend
    assert_not_equal 'Pierre', form.friend_id
  end

  test 'relations keeps only resource_id from params on update' do
    class FriendShipChangeForm < ActiveFormObjects::Base
      relations :friend
    end

    @jacques = @UserClass.new('Jacques', nil)
    assert_equal @pierre, @paul.friend
    form = FriendShipChangeForm.new({ friend_id: 'Jacques' }, @paul)

    assert form.valid?
    assert_equal 'Jacques', form.friend_id
  end

  test 'relations prioritize resource instead of resource_id when both are sent' do
    class FriendShipChangeForm < ActiveFormObjects::Base
      relations :friend
    end

    form = FriendShipChangeForm.new(friend: @pierre, friend_id: 'Jacques')

    assert form.valid?
    assert_equal @pierre, form.friend
    assert_equal 'Pierre', form.friend_id
  end

  test 'prepare can prepare an attribute by executing a method on it' do
    class PrepareForm < ActiveFormObjects::Base
      attributes :name
      prepare :name, with: :downcase
    end

    form = PrepareForm.new(name: 'CouCOUCOU')

    assert_equal 'coucoucou', form.name
  end
end
