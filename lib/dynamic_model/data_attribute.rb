module DynamicModel
  module DataAttribute
    extend ActiveSupport::Concern

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
    end

    class_methods do
      attr_accessor :dynamic_model_attribute_attrs
    end
  end
end
