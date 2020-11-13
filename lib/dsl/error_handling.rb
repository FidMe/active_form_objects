module Dsl
  module ErrorHandling
    def map_errors_to(form)
      yield
    rescue ActiveRecord::RecordInvalid, ActiveModel::ValidationError => e
      record = (e.try(:record) || e.model)
      initial_messages = record.errors.messages.as_json
      record.errors.clear
      initial_messages.each do |i|
        record.errors.add(form, i)
      end
      raise ActiveModel::ValidationError, record
    end
  end
end
