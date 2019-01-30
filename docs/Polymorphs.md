## Polymorphic relations

This feature allows to create a resource and its associated polymorphic relation with a single params object.

### Declaration

```ruby
class CommentForm < ActiveFormObjects::Base
  attributes :body
  polymorph :author, {
    admin: AdminForm,
    user: UserForm,
    customer: CustomerForm
  }
end

class UserForm < ActiveFormObjects::Base
  attributes :first_name
end

class AdminForm < ActiveFormObjects::Base
  attributes :login
end

class CustomerForm < ActiveFormObjects::Base
  attributes :last_name
end
```

### Usage

With the above example, you can send the following :

```json
{
  "body": "This form is awesome",
  "author": {
    "type": "user",
    "firstName": "Michaël"
  }
}
```

or

```json
{
  "body": "This form is awesome",
  "author": {
    "type": "customer",
    "lastName": "Villeneuve"
  }
}
```

or

```json
{
  "body": "This form is awesome",
  "author": {
    "type": "admin",
    "login": "mylogin"
  }
}
```
