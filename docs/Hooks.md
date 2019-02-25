## Hooks

Hooks allow you to call methods or blocks at specifics moment.

The way hooks work is very similar to the way ActiveRecord implemented it. It works just like you would expect it.

### Usage

Using a hook is very simple, either declare one or multiple methods to call on the hook :

```ruby
class RegistrationForm < ActiveFormObjects::Base
  before_save :say_hello, :say_hi

  def say_hello
    p 'hello'
  end

  def say_hi
    p 'hi'
  end
end
```

Or give it directly a block

```ruby
class RegistrationForm < ActiveFormObjects::Base
  before_save do
    p 'hello'
  end
end
```

### Available hooks

| Hook name        | Description                                                                                                                                   |
|------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| before_save      | Happens right when you call `save!`. It allows you to prepare the resource for validations or save.                                           |
| after_validation | Happens after before_save hooks and after validations. Allows you to modify the resource before saving without being validated.               |
| after_save       | Happens after saving the resource and its optional associated forms. Can be used for exemple to trigger other workflows (sending email, etc). |
