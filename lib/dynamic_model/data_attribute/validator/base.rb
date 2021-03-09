module DynamicModel::DataAttribute::Validator
  class Base
    include ActiveModel::Validations

    def initialize(validator_definition, attribute_id)
      @attribute_id = attribute_id
      @validator_definition = validator_definition.deep_stringify_keys
    end

    # Validate the validation_definition.
    # NOTE: This is NOT validating an actual data object. Just the @validator_definition. Refer to #validate_value
    #  for the actual validation of values from data_objects
    def validate
      return true unless @validator_definition.keys.any?

      validate_condition_presence && validator_specific_validations
    end

    # Validate whether the condition is specified in the validator_definition
    def validate_condition_presence
      unless @validator_definition["condition"].present?
        add_error(:blank_condition)
        return false
      end

      true
    end

    def condition
      @validator_definition["condition"] || {}
    end

    # To be overridden by children from this class, to allow validator specific validations
    def validator_specific_validations
      true
    end

    def add_error(error_key, error_data = {})
      errors.add(
        :validation_definition,
        error_key,
        **error_data.merge(
          { invalid_validation_key: self.class.name.demodulize.underscore }
        )
      )
    end

    def add_error_to_data_object(data_object, error_key, error_data = {}, error_scope = :data)
      data_object.errors.add(error_scope, error_key, **error_data)
    end
  end
end
