require 'minitest/autorun'
require 'active_form_objects'
require 'active_support'

require_relative '../helper'

HOOK_RESOURCE = Struct.new(:params) do
  def update!(params)
  end

  def self.all
  end
end

class Dsl::HooksTest < ActiveSupport::TestCase
  test 'can declare before_save' do
    form = HooksForm.new({}, nil, scope: :before)

    assert_raises('before_save') {
      form.save!
    }
  end

  test 'can declare after_save' do
    form = HooksForm.new({}, nil, scope: :after)

    assert_raises('after_save') {
      form.save!
    }
  end

  test 'can declare after_validation' do
    form = HooksForm.new({}, nil, scope: :middle)

    assert_raises('after_validation') {
      form.save!
    }
  end

  test 'can declare after_commit' do
    form = HooksForm.new({}, nil, scope: :commit)

    assert_raises('after_commit') {
      form.save!
    }
  end

  class HooksForm < ActiveFormObjects::Base
    resource HOOK_RESOURCE
    scope :before do
      before_save :raise_something
      def raise_something
        raise 'before_save'
      end
    end

    scope :middle do
      after_validation :say_nothing
      def say_nothing
        raise 'after_validation'
      end
    end

    scope :after do
      after_save {}
      after_save :raise_something_else
      def raise_something_else
        raise 'after_save'
      end
    end

    scope :commit do
      after_commit :raise_something
      def raise_something
        raise 'after_commit'
      end
    end
  end
end
