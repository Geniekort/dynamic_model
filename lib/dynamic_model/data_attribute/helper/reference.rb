module DynamicModel::DataAttribute::Helper
  class Reference < Base
    # Validate whether the value for this field is a valid reference value.
    #  A valid reference value is defined as:
    #   1. A positive integer
    #   2. 
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
        super.merge({
          "referred_data_type" => {
            required: true
          }
        })
      end
    end
  end
end
