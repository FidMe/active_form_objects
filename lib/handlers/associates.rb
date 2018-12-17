require 'active_support/core_ext/hash/reverse_merge'
require_relative 'base'

module Handlers
  class Associates < Base
    def handle
      (upper('@@associated_forms') || []).each do |form|
        @klass.instance_variable_set("@#{form[:name]}_form", form[:form])
      end
    end

    def save_associated_forms!
      (upper('@@associated_forms') || []).each do |associated|
        params = associated[:params].nil? ? @params[associated[:name]] : @klass.send(associated[:params])
        resource_to_save = @klass.send("#{associated[:name]}_to_update") rescue nil
        the_form = associated[:form]

        saved_form = the_form.new(params, resource_to_save).save!
        @klass.instance_variable_set("@#{associated[:name]}", saved_form)
      end
    end
  end
end
