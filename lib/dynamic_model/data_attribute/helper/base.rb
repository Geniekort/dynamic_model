module DynamicModel::DataAttribute::Helper
  class Base
    class << self
      def allowed_validation_definition_keys
        ["presence"]
      end
    end
  end
end
