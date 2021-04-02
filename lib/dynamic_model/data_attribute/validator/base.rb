module DynamicModel::DataAttribute::Validator
  class Base
    attr_reader :data_attribute
    
    def initialize(validator_definition, data_attribute)
      @validator_definition = validator_definition.deep_stringify_keys
      @data_attribute = data_attribute
    end

    def validate_value(_data_object)
      raise NotImplementedError, "#validate_value is not implemented for #{self.class}"
    end

    # Get the id of the data_attribute as a String
    def data_attribute_id_s
      @data_attribute.id.to_s
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
      data_attribute.errors.add(
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
