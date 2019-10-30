require 'minitest/autorun'
require 'mocha/minitest'
require 'active_form_objects'
require 'active_support'

require_relative '../helper'


class Dsl::SavingsTest < ActiveSupport::TestCase
  test 'can declare save bloc' do
    # No fail when loading below class is sufficient
  end

  test 'resource can be saved without bloc' do
    class WithoutBlocSavingForm < ActiveFormObjects::Base
      attributes :id
    end

    user_class = Struct.new(:id) do
      def attributes
        { id: id }
      end
    end

    user_class.any_instance.expects(:update!).once

    form = WithoutBlocSavingForm.new({ id: '123' }, user_class.new)
    form.save!
  end

  test 'save bloc is called' do
    MOCK = mock
    MOCK.expects(:a_method).once

    class AnotherSavingForm < ActiveFormObjects::Base
      attributes :id
      save do
        @resource.id = id
        MOCK.a_method
      end
    end

    user_class = Struct.new(:id) do
      def attributes
        { id: id }
      end
    end
    form = AnotherSavingForm.new({ id: '123' }, user_class.new)
    user = form.save!
    p user
    assert_equal '123', user.id
  end

  class SavingForm < ActiveFormObjects::Base
    save do
      p "lol"
    end
  end
end
