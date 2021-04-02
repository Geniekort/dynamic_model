module DynamicModel::DataAttribute::Validator
  class Presence < Base
    def validate_value(attribute_value, data_object)
      if condition == true && !attribute_value.present?
        add_error_to_data_object(
          data_object,
          :invalid_attribute_value,
          invalid_attribute_id: @attribute_id,
          value_error: :blank
        )
        return false
      end

      true
    end
  end
end
