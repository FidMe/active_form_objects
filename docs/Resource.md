## Resources

If you want to use an instance of a certain model in the form, you just need to declare the model to target as `resource`

Then you can use the instance as `@resource` in the form.

Omitting the declaration of the `resource` will make it impossible to do this

```ruby
class RegistrationForm < ActiveFormObjects::Base
end

RegistrationForm.new.save! # Will throw error
```

### Declaration

```ruby
class RegistrationForm < ActiveFormObjects::Base
  resource User
end
```

### Declaration with block

```ruby
class RegistrationForm < ActiveFormObjects::Base
  resource do |params|
    "User".constantize
  end
end
```

Since the block is given the list of params, this can allow you to dynamically search for the corresponding model.

## Usage

When using a form without any resource as second params, a new instance of the resource will automatically be created.

```ruby
form = RegistrationForm.new

puts form.resource
# => User#123

form.save! # Will result in doing User.new.save!
```

When using a form with a given resource to update, it will simply be used :

```ruby
form = UserUpdateForm.new({ name: 'Michael' }, @user)

puts form.resource
# => User#123 { name: 'michael' }
```
