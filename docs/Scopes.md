## Scopes

Scopes are used to act differently based on the way you call the form.
A good use case is to use it to handle role based modifications.
It is an good alternative to inheritance.

If you have a Post model, maybe that an admin would be allowed to modify more properties that the regular post author.

You could implement this by doing:

```ruby
class PostForm < ActiveFormObjects::Base
  attributes :title, :description

  scope :admin
    attributes :author, :publication_date
  end
end
```

That way when you call :

```ruby
PostForm.new({ title: 'A post', publication_date: '2019-25-02' })
```

Only the title field would be sent to the model.

However, if you call the form with the `:admin` scope, you will gain access to the `:author, :publication_date` attributes

```ruby
PostForm.new({ title: 'A post', publication_date: '2019-25-02' }, resource, scope: :admin)
```

### Scope VS Inheritance

The behavior achieved by scope is very similar to the behavior achieved by inheritance. 

In fact in order to implement this feature ActiveFormObjects creates a duplicated class containing the scope name and the scope content. This class then inherits from the base class.

In the above scenario, calling 

```ruby
PostFormScopeAdmin.new({ title: 'A post', publication_date: '2019-25-02' }, resource)
```

is similar to this

```ruby
PostForm.new({ title: 'A post', publication_date: '2019-25-02' }, resource, scope: :admin)
```

However we do not recommend you to directly call the created class as it wont benefit from the same autoloading as the rest of the rails classes. If you do this, some of your tests might be failing depending on the order files were loaded.

If you really want to call the class directly, you should put

```ruby
config.eager_load = false
```

in you test.rb file.

## When should I use inheritance ?

You may prefer to use inheritance if you think that the scope DSL adds to much lines to your parent form and it starts blurring the logic.

You may also prefer inheritance if you want to add a clearer barrier between the scope as you will probably create another class, another file, another test file, etc.

In general, you will probably prefer scope over inheritance.