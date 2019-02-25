## A developer guide to ActiveFormObjects debugging

Debugging a DSL based library can be hard.
Errors are often hidden inside the lib, raised at weird moments like class autoload, making it even harder to find the source of the problem.

This guide aims to make it easier for you to understand and debug your ActiveForms classes.

### The debug DSL

If you need a quick and simple way to understand the behavior of the form, you can simply write debug into your class.

```ruby
class PostForm < ActiveFormObjects::Base
  debug
end
```

By specifying this, a few logs will be output when you run your tests.

It will give more infos regarding :
- the way the form has been called
- params that were sent to the form
- the transformations that have been done on the params object
- the associated forms that will be called
- the resource associated with the form call

Please note that for now, logs are written directly into the Stdout with the `puts` method. This allow you to get the output without opening the log file.

## Help us make ActiveFormObjects even better

Whenever you encounter a non properly handled error, do not hesitate to find out what caused the issue by digging inside the library source code 

```
bundle show 'active_form_objects'
```

will tell you where to look !

File an issue whenever something unhandled happens.
