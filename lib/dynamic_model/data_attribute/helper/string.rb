module DynamicModel::DataAttribute::Helper
  class String < Base
    class << self
      def allowed_validation_definition_keys
        super + %w[length]
      end
    end
  end
end
