Dir[%(#{File.dirname(__FILE__)}/data_attribute/*.rb)].sort.each { |file| require file }

module DynamicModel
  module DataAttribute
    extend ActiveSupport::Concern

    class_methods do
      attr_accessor :dynamic_model_attribute_attrs
    end

    included do
      def self.dynamic_model_attribute_attrs
        {
          data_type_class_name: "DataType"
        }.merge(@dynamic_model_attribute_attrs || {})
      end

      def self.data_type_class_name
        class_name = dynamic_model_attribute_attrs[:data_type_class_name]

        raise DynamicModel::Error, "No class `#{class_name}` found" unless class_name.safe_constantize

        class_name
      end

      belongs_to :data_type, class_name: data_type_class_name

      validate :validate_attribute_type

      def validate_attribute_type
        type_module = "DynamicModel::DataAttribute::#{attribute_type}".safe_constantize

        unless type_module
          errors.add(:attribute_type, :invalid)
          return false
        end

        true
      end
    end
  end
end
