module DynamicModel
  module DataAttribute
    module Helper
      class Base
        def initialize(data_attribute)
          @data_attribute = data_attribute
        end

        def validate_data_object(data_object)
          attribute_value = data_attribute_value(data_object)

          validate_value_type(attribute_value) &&
            validate_dynamic_validations(attribute_value, data_object)
        end

        def validate_value_type(attribute_value)
          true
        end

        def validate_dynamic_validations(attribute_value, data_object)
          @data_attribute.active_validators.each do |validator|
            validator.validate_value(attribute_value, data_object)
          end
        end

        # Get the value for the specific attribute of this helper from the data_object
        def data_attribute_value(data_object)
          data_object.get_data[@data_attribute.id.to_s]
        end

        class << self
          def allowed_validation_definition_keys
            ["presence"]
          end
        end
      end
    end
  end
end
