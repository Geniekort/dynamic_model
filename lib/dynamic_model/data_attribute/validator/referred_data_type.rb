module DynamicModel::DataAttribute::Validator
  # A validator to validate whether a value actually refers to a DataObject
  #  of a specific DataType
  class ReferredDataType < Base
    def validate_value(_attribute_value, _data_object)
      true
    end

    # Validate whether the provided validation includes an id, referring to a correct
    #  DataType
    def validator_specific_validations
      unless condition.is_a? Hash
        add_error(:invalid_condition, condition_error: :invalid_type)
        return false
      end

      unless referred_data_type_id
        add_error(:invalid_condition, condition_error: :missing_referred_data_type_id)
        return false
      end

      unless referred_data_type
        add_error(:invalid_condition, condition_error: :unknown_data_type)
        return false
      end

      true
    end

    def referred_data_type_id
      condition["id"]
    end

    def referred_data_type
      @referred_data_type ||= data_attribute.class.data_type_class.find_by(id: referred_data_type_id)
    end
  end
end
