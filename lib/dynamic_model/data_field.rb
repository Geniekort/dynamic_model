module DynamicModel
  module DataField
    extend ActiveSupport::Concern

    included do
      def self.data_type_class_name
        raise DynamicModel::Error, "No class `DataField` found" unless "DataField".safe_constantize

        "DataField"
      end

      belongs_to :data_type, class_name: data_type_class_name
    end

    class_methods do
      def title
        "Een titel"
      end
    end
  end
end
