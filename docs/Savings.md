## Savings

**The save block**

The most common saving use case is as follow :

```ruby
def save!
  validate! # Validate the form, raise any errors if needed
  ActiveRecord::Base.transaction do # Do everything in a transaction
  # ... Do anything in between (send email, anything)
  @resource.save! # Save the resource
  @resource # Return the resource
rescue ActiveRecord::RecordInvalid => e # Catch any record invalid error
  e.record.errors.add(e.record.class.name, '') # Return the errors on the actual class instead of
  raise ActiveRecord::RecordInvalid.new(e.record) # Raise the actual error
end
```

You can solve most of this use case by using the save block.

Usage :

```ruby
class TestForm < BaseForm
  save do
    # ... Do anything in between (send email, anything)
  end
end
```

It will automatically validate the form, save, return the resource and catch & raise the actual error.
