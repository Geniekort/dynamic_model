module DynamicModel::DataAttribute::Helper
  class Number < Base
    # Override the parse_value to parse strings into numbers, to make sure
    #  data converges to the correct type
    def parse_value(value)
      case value
      when Numeric
        value
      when String
        value.to_f
      else
        raise ArgumentError, "Cannot parse values of type `#{value.class}`"
      end
    end

    # Validate whether the value for this field is a number
    def validate_value_type
      if data_attribute_value && !data_attribute_value.is_a?(::Numeric)
        add_error_to_data_object(
          :invalid_attribute_value,
          value_error: :invalid_type,
          invalid_attribute_id: @data_attribute.id.to_s
        )
        return false
      end

      true
    end
  end
end
