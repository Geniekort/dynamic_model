module DynamicModel
  module DataAttribute
    module Helper
      class Base
        attr_reader :data_attribute

        def initialize(data_attribute)
          @data_attribute = data_attribute
        end

        # Return the parsed version of `value`
        def parse_value(value)
          value
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
          active_validators.each do |active_validator|
            active_validator.validate_value(@data_object)
          end
        end

        # Validate whether validation definitions are valid
        # @param data_attribute The object to set validation errors on
        def validate_validation_definition
          self.class.allowed_validation_definitions.each do |validation_key, validator_specification|
            # If this validation is not defined, but is a mandatory validation, add a validation_error
            validator_definition = validation_definition[validation_key]

            unless validator_definition.present?
              if validator_specification[:required]
                data_attribute.errors.add(
                  :validation_definition,
                  :blank,
                  invalid_validation_key: validation_key
                )
              end
              next
            end

            validator_instance = validator(validation_key, validator_definition)
            validator_instance.validate
          end

          data_attribute.errors.none?
        end

        # Create an instance for a specific validator type
        def validator(validation_key, validator_defintion)
          validator_class_name = "DynamicModel::DataAttribute::Validator::#{validation_key.camelcase}"
          validator_class = validator_class_name.safe_constantize
          unless validator_class
            raise "Missing validator class for #{validation_key}, expected class `#{validator_class_name}` to exist."
          end

          validator_class.new(validator_defintion, data_attribute)
        end

        # Return a list of all validators for which a non-null definition is provided in validation_definition,
        #  i.e. for each type of validation defined in the validation_definition, or that is required as
        #  present validators
        def active_validators
          self.class.allowed_validation_definitions.map do |validation_key, _|
            if (validator_definition = validation_definition[validation_key]).present?
              validator(validation_key, validator_definition)
            end
          end.compact
        end

        class << self
          # Return a hash of all possible validation definitions. Each key/value(hash) pair
          #  indicates that this validation is possible. If in the value hash, required: true,
          #  then this validator has to be present, and is not optional
          def allowed_validation_definitions
            {
              "presence" => { required: false }
            }
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
