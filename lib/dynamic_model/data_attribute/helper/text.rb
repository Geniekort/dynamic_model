module DynamicModel::DataAttribute::Helper
  class Text < Base
    def validate_value_type
      if data_attribute_value && !data_attribute_value.is_a?(::String)
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
      def allowed_validation_definition_keys
        super + %w[length]
      end
    end
  end
end
