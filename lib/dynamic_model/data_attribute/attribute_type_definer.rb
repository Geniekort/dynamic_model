module DynamicModel::DataAttribute
  # This module ensures that a DataAttribute includes all functionality that is necessary
  #  for each specific attribute_type
  module AttributeTypeDefiner
    extend ActiveSupport::Concern

    included do
      validate :validate_attribute_type
      validate :validate_validation_definition
    end

    def validate_validation_definition
      return unless attribute_type_helper_class # Early bail-out since other validation will fail

      attribute_type_helper.validate_validation_definition
    end

    # Find the class that includes all attribute type specific helper methods. E.g. getters/setters
    def attribute_type_helper_class
      "DynamicModel::DataAttribute::Helper::#{attribute_type}".safe_constantize
    end

    # Create an instance of the attribute type helper
    def attribute_type_helper
      attribute_type_helper_class.new(self)
    end

    def validate_attribute_type
      unless attribute_type_helper_class
        errors.add(:attribute_type, :invalid)
        return false
      end

      true
    end

    # Validate the value for this data_attribute in a data_object 
    def validate_data_object(data_object)
      attribute_type_helper.validate_data_object(data_object)
    end
  end
end
