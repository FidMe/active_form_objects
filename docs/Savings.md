## Savings

Saving a Form is a **key concept**.

Even though you can declare and use any method inside a Form Object, calling `save!` should be the default option.

Saving a form does not necessarily imply calling `.save` on an active record object.
You can indeed use the `save!` method to start a background job, send an email, anything...

### The save! method

By default, `ActiveFormObjects::Base` provides you with a `.save!` method on the instance of a form.

All this does is :

- validates the form validations
- saving the given resource in a transaction
- handling errors
- returning the created resource

Most form will in fact override the `.save!` method and add their custom logic.

You can use the bellow save block in order to benefit from `ActiveFormObjects` intelligence meanwhile adding your own business logic.

### The save block

The most common saving use case is as follow :

```ruby
def save!
  validate!
  ActiveRecord::Base.transaction do
    # ... Do anything in between (send email, anything)
    @resource.save!
  end
  @resource # Return the resource
rescue ActiveRecord::RecordInvalid => e
  e.record.errors.add(e.record.class.name, '')
  raise ActiveRecord::RecordInvalid.new(e.record) # Raise the actual error
end
```

You can easily clean up this use case by using the save block.

Usage :

```ruby
class TestForm < BaseForm
  save do
    # ... Do anything in between (send email, anything)
  end
end
```

Your form will automatically be validated, the resource will be returned, errors will be handled.
