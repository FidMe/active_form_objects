## Attributes

The attributes declaration is a clean replacement for strong params in rails.

You are probably declaring the following in your Rails controller

```ruby
def user_params
  params.require(:user).permit(:name, :last_name)
end
```

With ActiveFormObjects, you can delegate this to you form layer

```ruby
class ProgramForm < BaseForm
  attributes :name, :last_name
end
```

Meaning that your controller can call

```ruby
def create
  ProgramForm.new(params)
end
```

without touching the `params` object.

### Declaration

```ruby
class ProgramForm < BaseForm
  resource Loyalty::Program
  attributes :name
end
```

By declaring the above, you allow the controller (or anything), to do this :

```ruby
# Create a Loyalty program
ProgramForm.new(name: 'Coucou').save!

# Update a Loyalty program
ProgramForm.new(name: 'Coucou', program).save!
```

Thanks to the `resource` declaration, the form will know which model to target.
Thanks to the `attributes` declaration, the form will know which attributes to pass to the model.

### Delegation

If you need to create a resource that is cut into several tables, for example :

```ruby
  class User::Entity
    has_one :profile
    has_one :auth
  end

  class User::Profile
    belongs_to :entity
  end

  class User::Auth
    belongs_to :entity
  end
```

You may want to hide this behavior to the frontend, and therefore receive a params hash resembling to this :

```json
{ "name": "Michael", "email": "mvilleneuve@fidme.com", "password": "coucou" }
```

You will need to know which attribute goes to which sub-model.
In order to implement that you can do

```ruby
class RegistrationForm
  delegate :email, to: :entity
  delegate :name, to: :profile
  delegate :password, to: :auth
end
```

### Default values

In order to set a default value to a param you can declare the following

```ruby
class RegistrationForm
  set_default "your value :D", to: [:any, :attribute]
end
```

```ruby
puts RegistrationForm.new({ any: 'lol', coucou: 'lol' })
# => any: 'lol', attribute: 'your value :D', coucou: 'lol'
```

### Default values

In order to lock a value, ie: to make sure params won't be able to modify that value, you can declare :

```ruby
class RegistrationForm
  ensure_value :is_published, false
end
```

```ruby
puts RegistrationForm.new(is_published: true)
# => is_published: false
```
