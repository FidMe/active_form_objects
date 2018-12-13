# require 'minitest/autorun'
# require 'active_form_objects'
# require 'active_support'

# class PolymorphicTest < ActiveSupport::TestCase
#   setup do
#     @UserClass = Struct.new(:id, :friend, :friend_id) do
#       def attributes
#         { id: id, friend_id: friend.id }
#       end
#     end
#   end

#   test 'receive' do
#     class PostForm < ActiveFormObjects::Base
#       polymorph :published,
#         scannable: Struct,
#         stampable: Struct
#     end

#     form = PostForm.new({}).save!

#   end
# end
