## Error handling with ActiveFormObjects

By default, most ActiveFormObjects error will be very familiar to you.
In order to stick to Rails spirit, we have decided to let ActiveRecord raise its own errors.

In other words, you won't be forced to handle your errors any differently compared to a standard Rails stack.

Since ActiveFormObjects uses ActiveModel, ActiveFormObjects errors are standard `ActiveModel::Validation` errors.
They look very similar to an `ActiveRecord::RecordInvalid` error.

If you need more control over ActiveFormObjects errors, you may use the following method anywhere in your form code.

### map_errors_to

```ruby
class RegistrationForm < ActiveFormObjects::Base
  save do
    map_errors_to(:something) do
      OtherForm.new({}).save!
    end
  end
end
```

This will allow you to scope errors coming from other models or classes to your parent form.
The use cases we use it for is the following

```ruby
class CustomForm < ActiveFormObjects::Base
  set_default value: {}, to: [:retailer, :program, :user_program]

save do
    map_errors_to(:retailer)     { @retailer = RetailerForm.new(@retailer).save! }
    map_errors_to(:program)      { @program  = ProgramForm.new(@program.merge(retailer: @retailer)).save! }
    map_errors_to(:user_program) { @resource = UserProgramForm.new(@user_program.merge(entity: @program, user: @user), @resource).save! }
  end
end
```

When an error is raised by `RetailerForm` or `ProgramForm`, `map_errors_to` will change `ActiveRecord` error hash from this :

```json
{
  "name": ["name is mandatory"],
  "value": ["barcode value must be valid"]
}
```

to this :

```json
{
  "retailer": {
    "name": ["name is mandatory"]
  },
  "user_program": {
    "value": ["barcode value must be valid"]
  }
}
```

allowing us to give the user a much more detailed feedback on where the error comes from.
