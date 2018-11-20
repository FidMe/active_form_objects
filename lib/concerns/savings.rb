require 'active_support'

module Savings
  extend ActiveSupport::Concern

  @@associated_forms = {}

  class_methods do
    def associated(key, form, params = nil)
      @@associated_forms[name] ||= []
      @@associated_forms[name] << { name: key, form: form, params: params }

      set_default value: {}, to: key
    end

    def save(&block)
      define_method(:save!) do
        with_rescue do
          ActiveRecord::Base.transaction do
            validate!
            instance_eval(&block)
            @resource.try(:save!)
          end
          @resource
        end
      end
    end
  end

  def save!
    with_rescue do
      if @@associated_forms[self.class.name].nil?
        validate!
        @resource.update!(@params)
        @resource
      else
        save_associated_forms!
      end
    end
  end

  def save
    save!
  rescue
    false
  end

  def save_associated_forms!
    (@@associated_forms[self.class.name] || []).each do |associated|
      params = associated[:params].nil? ? @params[associated[:name]] : send(associated[:params])
      resource_to_save = send("#{associated[:name]}_to_update") rescue nil
      @TheForm = associated[:form]

      saved_form = @TheForm.new(params, resource_to_save).save!
      instance_variable_set("@#{associated[:name]}", saved_form)
    end
  end

  def set_associated_forms
    (@@associated_forms[self.class.name] || []).each do |form|
      instance_variable_set("@#{form[:name]}_form", form[:form])
    end
  end

  def with_rescue
    yield
  rescue ActiveRecord::RecordInvalid => e
    e.record.errors.add(e.record.class.name, '')
    raise ActiveRecord::RecordInvalid.new(e.record)
  end
end
