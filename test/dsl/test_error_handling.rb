require 'minitest/autorun'
require 'active_form_objects'
require 'active_support'

require_relative '../helper'

class Dsl::ErrorHandlingTest < ActiveSupport::TestCase
  test 'map_errors_to allows to remap errors to a specific key' do
    class MapErrorRelationForm < ActiveFormObjects::Base
      validates :coucou, presence: true
    end
    class MapErrorToForm < ActiveFormObjects::Base
      save do
        map_errors_to(:key) do
          MapErrorRelationForm.new({}).save!
        end
      end
    end

    exception = assert_raises(ActiveModel::ValidationError) do
      MapErrorToForm.new({}).save!
    end
    assert exception.model.errors.key?(:key), "Should have a key 'key'"
    assert_not exception.model.errors.key?('coucou'), "Should not have a key 'coucou' anymore"
    assert_not_nil exception.model.errors[:key]['coucou']
  end
end
