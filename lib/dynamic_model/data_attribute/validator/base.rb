module DynamicModel::DataAttribute::Validator
  class Base
    include ActiveModel::Validations

    def initialize(validator_definition)
      @validator_definition = validator_definition.deep_stringify_keys
    end

    # Validate the validation_definition.
    # NOTE: This is NOT validating an actual data object. Just the @validator_definition
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
  end
end
