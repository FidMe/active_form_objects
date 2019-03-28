require 'minitest/autorun'
require 'active_form_objects'
require 'active_support'

require_relative '../helper'

class Dsl::ScopesTest < ActiveSupport::TestCase
  test 'can declare attributes in custom scope' do
    form = TestScopForm.new({ id: '123', admin_only: 'lol' }, nil, scope: :admin)
    assert_equal 'lol', form.params[:admin_only]

    form = TestScopForm.new(id: '123', admin_only: 'lol')
    assert_nil form.params[:admin_only]
  end

  test 'scope raises errors correctly' do
    form = TestScopForm.new({}, nil, scope: :admin)
    assert_not form.valid?
    assert form.errors.key?(:admin_only)
    assert form.errors.key?(:id)
  end

  test "multiple scope do not override declared vars" do
    form = TestMultipleScopForm.new({}, nil, scope: :admin)
    other = TestMultipleScopForm.new({}, nil, scope: :other)

    assert_not form.coucou
    assert other.coucou
  end

  class TestMultipleScopForm < ActiveFormObjects::Base
    ensure_value :coucou, false

    scope :admin do
      ensure_value :coucou, false
    end

    scope :other do
      ensure_value :coucou, true
    end
  end

  test 'cannot use undeclared scope' do
    assert_raises(ActiveFormObjects::DslError) do
      TestScopForm.new({}, nil, scope: :coucou)
    end
  end

  class TestScopForm < ActiveFormObjects::Base
    attributes :id
    validates :id, presence: true

    scope :admin do
      attributes :admin_only
      validates :admin_only, presence: true
    end
  end
end
