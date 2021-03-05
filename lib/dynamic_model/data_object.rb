module DynamicModel
  module DataObject
    extend ActiveSupport::Concern

    included do
      def self.dynamic_model_data_object_attrs
        {
          data_column_name: "data",
          data_type_class_name: "DataType"
        }.merge(@dynamic_model_data_object_attrs || {})
      end

      def self.data_type_class_name
        class_name = dynamic_model_data_object_attrs[:data_type_class_name]

        raise DynamicModel::Error, "No class `#{class_name}` found" unless class_name.safe_constantize

        class_name
      end

      belongs_to :data_type, class_name: data_type_class_name
    end

    class_methods do
      attr_accessor :dynamic_model_data_object_attrs
    end

    def get_data
      send(self.class.dynamic_model_data_object_attrs[:data_column_name])
    end
  end
end
