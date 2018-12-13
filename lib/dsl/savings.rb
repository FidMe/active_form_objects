require 'active_support'
require 'active_record'
require_relative '../handlers/savings'

module Dsl
  module Savings
    extend ActiveSupport::Concern

    class_methods do
      def save(&block)
        define_method(:save!) do
          Handlers::Savings.new(self).save!(&block)
        end
      end
    end

    def save!
      Handlers::Savings.new(self).save!
    end

    def save
      save!
    rescue
      false
    end
  end
end
