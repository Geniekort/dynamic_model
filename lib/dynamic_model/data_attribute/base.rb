module DynamicModel::DataAttribute
  module Base
    extend ActiveSupport::Concern

    included do
      validate :validate_attribute_type
      validate :validate_validation_definition
    end

    # Validate whether validation definitions are valid
    def validate_validation_definition
      return unless attribute_type_helper # Early bail-out since other validation will fail 

      attribute_type_helper.allowed_validation_definition_keys.each do |validation_key|
        next unless (validator_definition = validation_definition[validation_key]).present?

        validator_instance = validator(validation_key, validator_definition)

        errors.merge!(validator_instance.errors) unless validator_instance.validate
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

      validator_class.new(validator_defintion)
    end

    # Find the module that includes all attribute type specific helper methods. E.g. getters/setters
    def attribute_type_helper
      "DynamicModel::DataAttribute::Helper::#{attribute_type}".safe_constantize
    end

    def validate_attribute_type
      unless attribute_type_helper
        errors.add(:attribute_type, :invalid)
        return false
      end

      true
    end
  end
end
