module DynamicModel::DataAttribute
  module ValidatorHelper
    extend ActiveSupport::Concern

    included do
      validate :validate_attribute_type
      validate :validate_validation_definition
    end

    # Validate whether validation definitions are valid
    def validate_validation_definition
      return unless attribute_type_helper_class # Early bail-out since other validation will fail 

      attribute_type_helper_class.allowed_validation_definition_keys.each do |validation_key|
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

      validator_class.new(validator_defintion, self.id.to_s)
    end

    # Return a list of all validators for which a non-null definition is provided in validation_definition, 
    #  i.e. for each type of validation defined in the validation_definition
    def active_validators
      attribute_type_helper_class.allowed_validation_definition_keys.map do |validation_key|
        if (validator_definition = validation_definition[validation_key]).present?
          validator(validation_key, validator_definition)
        end
      end.compact
    end

    # Find the class that includes all attribute type specific helper methods. E.g. getters/setters
    def attribute_type_helper_class
      "DynamicModel::DataAttribute::Helper::#{attribute_type}".safe_constantize
    end

    # Create an instance of the attribute type helper
    def attribute_type_helper
      attribute_type_helper_class.new(self)
    end


    def validate_attribute_type
      unless attribute_type_helper_class
        errors.add(:attribute_type, :invalid)
        return false
      end

      true
    end

    # Validate the value for this data_attribute in a data_object 
    def validate_data_object(data_object)
      attribute_type_helper.validate_data_object(data_object)
    end
  end
end
