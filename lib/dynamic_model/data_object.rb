module DynamicModel
  module DataObject
    extend ActiveSupport::Concern

    included do
      attr_accessor :data_type_class

      def self.data_type_class_name
        raise DynamicModel::Error, "No class `DataField` found" unless "DataField".safe_constantize

        "DataField"
      end

      belongs_to :data_type, class_name: data_type_class_name

      def self.dynamic_model_data_object_attrs
        {
          data_column_name: "data"
        }.merge(@dynamic_model_data_object_attrs || {})
      end
    end

    class_methods do
      def title
        "Een titel"
      end
    end

    def get_data
      send(self.class.dynamic_model_data_object_attrs[:data_column_name])
    end
  end
end
