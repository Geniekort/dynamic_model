module DynamicModel::DataObject
  class Validator
    def initialize(data_object)
      @data_object = data_object
    end

    # Validate a data object against its data model
    def validate
      validate_present_attributes
      validate_attribute_values
    end

    def validate_attribute_values
      data_attributes.each do |attribute|
        attribute.validate_data_object(@data_object)
      end
    end

    # For each attribute of the data type, check if the provided value for this data object
    #  is valid.
    def attribute_values
      data_attributes.each do |attribute|
        attribute.validate_data_object(@data_object)
      end
    end

    # Validate whether all attribute values present in the data field are actually
    #  part of the data model
    def validate_present_attributes
      allowed_attribute_ids = data_attributes.map(&:id).map(&:to_s)

      invalid_attribute_ids = @data_object.get_data.keys - allowed_attribute_ids
      if invalid_attribute_ids.any?
        add_error(:invalid_attribute_ids, invalid_attribute_ids: invalid_attribute_ids)
        return false
      end

      true
    end

    # Return the list of attributes that define the data type of the data object we are validating
    def data_attributes
      @data_attributes ||= @data_object.data_type.data_attributes
    end

    # Add an error to the data_object
    def add_error(validation_key, error_data = {}, error_scope = :data)
      @data_object.errors.add(error_scope, validation_key, **error_data)
    end
  end
end
