module DynamicModel
  module DataType
    extend ActiveSupport::Concern

    included do
      def self.data_field_class_name
        default_class = @dynamic_model_attrs[:data_field_class_name]
        raise DynamicModel::Error, "No class `#{default_class}` found" unless default_class.safe_constantize

        default_class
      end

      def self.data_object_class_name
        default_class = @dynamic_model_attrs[:data_object_class_name]
        raise DynamicModel::Error, "No class `#{default_class}` found" unless default_class.safe_constantize

        default_class
      end

      def self.data_object_class
        data_object_class_name.safe_constantize
      end

      def self.data_field_class
        data_field_class_name.safe_constantize
      end


      has_many :data_fields, class_name: data_field_class_name
      has_many :data_objects, class_name: data_object_class_name

      data_object_class.include DynamicModel::DataObject
      data_field_class.include DynamicModel::DataField
    end

    class_methods do
      def title
        "Een titel"
      end
    end
  end
end
