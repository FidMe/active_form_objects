require 'minitest/autorun'
require 'active_form_objects'
require 'active_support'

require_relative '../helper'

USER = Struct.new(:id) do
  def attributes
    { id: id }
  end

  def reload
    true
  end

  def profile
    nil
  end
end

PROFILE = Struct.new(:id, :parent_id) do
  def attributes
    { id: id }
  end
end

class Dsl::DelegateTest < ActiveSupport::TestCase
  test 'can delegate params to another form' do
    user_instance = USER.new('123')
    
    USER
      .expects(:new)
      .once
      .returns(user_instance)

    USER
      .any_instance
      .expects(:update!)
      .with('id' => '123')
      .once

    PROFILE
      .any_instance
      .expects(:update!)
      .with('name' => 'coucou', 'user_id' => '123')
      .once

    DelegateUserForm.new(id: '123', name: 'coucou').save!
  end

  class DelegateUserProfileForm < ActiveFormObjects::Base
    resource PROFILE
    attributes :name
    relations :user
  end

  class DelegateUserForm < ActiveFormObjects::Base
    resource USER
    attributes :id
    delegate :name, to: {
      relation: :profile,
      form: DelegateUserProfileForm,
      foreign_key: :user_id
    }
  end
end
