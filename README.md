# ActiveFormObjects

[![Build Status](https://travis-ci.org/FidMe/active_form_objects.svg?branch=master)](https://travis-ci.org/FidMe/active_form_objects)
[![Gem Version](https://badge.fury.io/rb/active_form_objects.svg)](https://badge.fury.io/rb/active_form_objects)

Since making Form Objects with Rails can be a pain, this gem aims to facilitate the creation of a dedicated layer.

Slim up your controllers, handle validations outside of your models, pull out logic that does not belong to your models.

## Menu

**Getting started**

- [Installation](https://github.com/FidMe/active_form_objects#installation)
- [The Form Layer](https://github.com/FidMe/active_form_objects#the-form-layer)
- [A basic example](https://github.com/FidMe/active_form_objects#a-basic-example)

**Documentation**

- [Resource](https://github.com/FidMe/active_form_objects/blob/master/docs/Resource.md)
- [Attributes](https://github.com/FidMe/active_form_objects/blob/master/docs/Attributes.md)
- [Relations](https://github.com/FidMe/active_form_objects/blob/master/docs/Relations.md)
- [ActiveModel](https://api.rubyonrails.org/classes/ActiveModel/Model.html)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_form_objects'
```

Execute

```bash
$ bundle install
```

Then, depending on your usage you may want to create an `app/forms` folder in your Rails application.

You will put all your forms inside of it.

A form is just a class that extends `ActiveFormObjects::Base`.

## The Form layer

![The form layer](https://raw.githubusercontent.com/FidMe/active_form_objects/master/docs/images/form_layer.png)

A form object can be decoupled into three parts.

- Params filtering and validating
- Any business logic
- Communication with model

Even though it seems to be a lot to handle for a single class, remember that most of it used to be (poorly done) in your controller.

### A basic example

You have a `User` model.
This model has a password field and on creation you want to verify that password and `password_confirm` match.

This logic does not belong to your `User` model.

Indeed, `User` only needs to know that the `User` has a password, furthemore, `User` does not have a `password_confirm` field, so you would need to add attr_accessor and custom validation into your `User` model.

Seems a bit to much to handle for a `User` model that is also used in a thousand other use cases...

`ActiveFormObjects` allows you to refactor this logic and put it where it belongs.

In this case :

```ruby
class RegistrationController
  def create
    render json: RegistrationForm.new(params).save!
  end
end

class RegistrationForm < ActiveFormObjects::Base
  resource User
  attributes :email :password, :password_confirm
  validate :confirmation_match

  def confirmations_match
    errors.add(:password, "must match password_confirm") if password != password_confirm
  end
end

class User
  validates :email, :password, presence: true
end
```

On top of all these feature, `ActiveFormObjects` gives use access to the entire [Active Model](https://guides.rubyonrails.org/active_model_basics.html) stack.

## Anything is missing ?

File an issue
