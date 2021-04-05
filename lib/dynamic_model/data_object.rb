Dir[%(#{File.dirname(__FILE__)}/data_object/**/*.rb)].sort.each { |file| require file }

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

        # raise DynamicModel::Error, "No class `#{class_name}` found" unless class_name.safe_constantize

        class_name
      end

      belongs_to :data_type, class_name: data_type_class_name, required: true

      validate :validate_data_with_data_model
    end

    class_methods do
      attr_accessor :dynamic_model_data_object_attrs
    end

    def get_data
      send(self.class.dynamic_model_data_object_attrs[:data_column_name]) || {}
    end

    # Get the parsed stored data for an attribute
    def get_data_by_attribute(attribute)
      attribute.parse_value(get_raw_data_by_attribute(attribute))
    end

    # Get the raw stored data for an attribute
    def get_raw_data_by_attribute(attribute)
      get_raw_data_by_attribute_id(attribute.id.to_s)
    end

    # Get the raw stored data for an attribute id
    def get_raw_data_by_attribute_id(attribute_id)
      get_data[attribute_id]
    end

    # Validate this data object against its data model.
    def validate_data_with_data_model
      return unless data_type # Early bail-out if data_type is not present. Other validation will fail

      DynamicModel::DataObject::Validator.new(self).validate
    end
  end
end
