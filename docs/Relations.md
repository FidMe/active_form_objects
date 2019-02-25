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
