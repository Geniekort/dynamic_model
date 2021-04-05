module DynamicModel::DataAttribute::Helper
  class Reference < Base
    # Override the parse_value to parse strings into numbers, to make sure
    #  data converges to the correct type
    def parse_value(value)
      return unless value

      object_id = case value
                  when Numeric
                    value
                  when String
                    value.to_i
                  else
                    raise ArgumentError, "Cannot parse values of type `#{value.class}`"
                  end

      referred_data_type.data_objects.find_by(id: object_id)
    end

    def referred_data_type_id
      validation_definition.dig("referred_data_type", "condition", "id")
    end

    def referred_data_type
      @referred_data_type ||= data_attribute.class.data_type_class.find_by(id: referred_data_type_id)
    end

    # Validate whether the value for this field is a valid reference value.
    #  A valid reference value is defined as: a positive integer
    def validate_value_type
      if data_attribute_value && !(data_attribute_value.is_a?(::Integer) && data_attribute_value > 0)
        add_error_to_data_object(
          :invalid_attribute_value,
          value_error: :invalid_type,
          invalid_attribute_id: @data_attribute.id.to_s
        )
        return false
      end

      true
    end

    class << self
      # Add the referred_data_type as a validations that needs to be executed mandatory
      def allowed_validation_definitions
        super.merge(
          {
            "referred_data_type" => {
              required: true
            }
          }
        )
      end
    end
  end
end
