Dir[%(#{File.dirname(__FILE__)}/data_attribute/**/*.rb)].sort.each { |file| require file }

module DynamicModel
  module DataAttribute
    extend ActiveSupport::Concern

    class_methods do
      attr_accessor :dynamic_model_attribute_attrs
    end

    included do
      include DynamicModel::DataAttribute::AttributeTypeDefiner

      def self.dynamic_model_attribute_attrs
        {
          data_type_class_name: "DataType"
        }.merge(@dynamic_model_attribute_attrs || {})
      end

      def self.data_type_class_name
        class_name = dynamic_model_attribute_attrs[:data_type_class_name]

        # raise DynamicModel::Error, "No class `#{class_name}` found" unless class_name.safe_constantize

        class_name
      end

      def self.data_type_class
        data_type_class_name.safe_constantize
      end

      belongs_to :data_type, class_name: data_type_class_name

      validates :name, presence: true
    end
  end
end
