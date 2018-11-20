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

### Form associations (beta feature not sure if relevant 😄)

Use case to solve :

Whenever you have a form that depends on other forms, you may want to consider using the `associated` method.

For instance :

```ruby
  class CustomProgramForm < BaseForm
    set_default value: {}, to: %i[retailer content program of_user]
    attributes :user

    def save!
      @retailer = ProgramForm.new(@params[:retailer] || {}, retailer_to_update).save!
      @content = ContentForm.new(@params[:content] || {}, content_to_update).save!

      UserProgramForm.new(user_program_params.merge(user: @user), @resource).save!
    end
  end

  class ProgramForm < BaseForm
    resource Loyalty::Program
    ensure_value :is_custom, true
    attributes :name, :is_custom, :retailer, :content
  end

  class ContentForm < BaseForm
    resource Loyalty::Scannable::Entity
    attributes :code_type, :code_group
  end

  class UserProgramForm < BaseForm
    resource Loyalty::Scannable::OfUser
    attributes :entity, :user, :value, :note
  end
end
```

can be written :

```ruby
class CustomProgramForm < ProgramCreationForm
  associated :retailer, Retailer::CustomForm
  associated :content, Scannable::EntityForm
  associated :program, CreationForm
end
```
