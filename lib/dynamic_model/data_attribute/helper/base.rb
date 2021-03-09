module DynamicModel
  module DataAttribute
    module Helper
      class Base
        def initialize(data_attribute)
          @data_attribute = data_attribute
        end

        # Validate a data object for the specific attribute which we are helping.
        def validate_data_object(data_object)
          @data_object = data_object

          validate_value_type &&
            validate_dynamic_validations
        end

        # Validate whether the type of the value is matching the data attribute type
        def validate_value_type
          true
        end

        # Validate the attribute value against the dynamic validations defined in validation_definition
        def validate_dynamic_validations
          active_validators.each do |validator|
            validator.validate_value(data_attribute_value, @data_object)
          end
        end

        # Validate whether validation definitions are valid
        # @param data_attribute The object to set validation errors on
        def validate_validation_definition(data_attribute)
          self.class.allowed_validation_definition_keys.each do |validation_key|
            next unless (validator_definition = validation_definition[validation_key]).present?

            validator_instance = validator(validation_key, validator_definition)

            data_attribute.errors.merge!(validator_instance.errors) unless validator_instance.validate
          end

          true
        end

        # Create an instance for a specific validation type
        def validator(validation_key, validator_defintion)
          validator_class_name = "DynamicModel::DataAttribute::Validator::#{validation_key.camelcase}"
          validator_class = validator_class_name.safe_constantize
          unless validator_class
            raise "Missing validator class for #{validation_key}, expected class `#{validator_class_name}` to exist."
          end

          validator_class.new(validator_defintion, @data_attribute.id.to_s)
        end

        # Return a list of all validators for which a non-null definition is provided in validation_definition,
        #  i.e. for each type of validation defined in the validation_definition
        def active_validators
          self.class.allowed_validation_definition_keys.map do |validation_key|
            if (validator_definition = validation_definition[validation_key]).present?
              validator(validation_key, validator_definition)
            end
          end.compact
        end

        class << self
          def allowed_validation_definition_keys
            ["presence"]
          end
        end

        private

        # Get the value for the specific attribute of this helper from the data_object
        def data_attribute_value
          @data_object.get_data[@data_attribute.id.to_s]
        end

        def validation_definition
          @data_attribute.validation_definition
        end

        def add_error_to_data_object(error_key, error_data = {}, error_scope = :data)
          @data_object.errors.add(error_scope, error_key, **error_data)
        end
      end
    end
  end
end
