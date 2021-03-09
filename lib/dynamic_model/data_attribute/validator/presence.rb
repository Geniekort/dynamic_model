module DynamicModel::DataAttribute::Validator
  class Presence < Base
    def validate_value(attribute_value, data_object)
      puts "condition: #{condition}"
      puts "attr: #{attribute_value}"
      if condition == true && !attribute_value.present?
        add_error_to_data_object(
          data_object,
          :invalid_attribute_value,
          invalid_attribute_id: @attribute_id,
          value_error: :blank
        )
      end
    end
  end
end
