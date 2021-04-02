module DynamicModel::DataAttribute::Validator
  class Presence < Base
    def validate_value(data_object)
      attribute_value = data_object.get_data[data_attribute_id_s]

      if condition == true && !attribute_value.present?
        add_error_to_data_object(
          data_object,
          :invalid_attribute_value,
          invalid_attribute_id: data_attribute_id_s,
          value_error: :blank
        )
        return false
      end

      true
    end
  end
end
