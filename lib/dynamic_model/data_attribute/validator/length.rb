module DynamicModel::DataAttribute::Validator
  class Length < Base


    # Validate whether min and/or max are provided as a condition
    def validator_specific_validations
      unless condition.is_a? Hash
        add_error(:invalid_condition, condition_error: :invalid_type)
        return false
      end
      
      unless condition["max"] || condition["min"]
        add_error(:invalid_condition, condition_error: :missing_min_or_max)
        return false
      end

      if condition["max"] && !condition["max"].is_a?(Integer)
        add_error(:invalid_condition, condition_error: :invalid_max)
        return false
      end

      if condition["min"] && !condition["min"].is_a?(Integer)
        add_error(:invalid_condition, condition_error: :invalid_min)
        return false
      end

      true
    end
  end
end
