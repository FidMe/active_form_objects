## Relations

Whenever you have foreign keys, you do not need to use attributes or validates. If you do so, you will end up with a long list of params :

```ruby
class RegistrationForm
  attributes :entity, :entity_id, :user, :user_id
  validates :entity, :user
end
```

Instead, declare 'relations', which 'validates' foreign_key's presence and declare attributes and attributes_id.

```ruby
class RegistrationForm
  relations :entity, :user
end
```

If you do not want to add presence validations to the relation, you can add an option hash at the end of the declaration :

```ruby
  relations :entity, :user, skip_validations: true
```

### Form associations (beta feature not sure if relevant 😄)

Use case to solve :

Whenever you have a form that depends on other forms, you may want to consider using the `associated` method.

For instance :

```ruby
  class CarManufacturingForm < ActiveFormObjects::Base
    def save!
      @wheels = WheelsForm.new(@params[:wheels] || {}).save!
      @engine = EngineForm.new(@params[:engine] || {}).save!
      @body = BodyForm.new(@params[:body] || {}).save!

      AssemblingForm.new({
        wheels: @wheels,
        engine: @engine,
        body: @body
      }).save!
    end
  end

  class WheelsForm < ActiveFormObjects::Base
    resource Wheel
    attributes :size, :color
  end

  class EngineForm < ActiveFormObjects::Base
    resource Engine
    attributes :power, :torque
  end

  class BodyForm < ActiveFormObjects::Base
    resource Body
    attributes :size, :paint
  end

  class AssemblingForm < ActiveFormObjects::Base
    resource Car
    attributes :body, :wheels, :engine
  end
end
```

can be written :

```ruby
class CarManufacturingForm < ActiveFormObjects::Base
  associated :body, BodyForm
  associated :wheels, WheelsForm
  associated :engine, EngineForm

  save do
    AssemblingForm.new(
      body: @body,
      wheels: @wheels,
      engine: @engine
    ).save!
  end
end
```
