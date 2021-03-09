module DynamicModel
  module ActiveRecord
    def dynamic_model(attributes={})
      puts "+=========================!!!"

      @dynamic_model_attrs = {
        data_attribute_class_name: "DataAttribute", data_object_class_name: "DataObject"
      }.merge(attributes)

      include DynamicModel::DataType
    end

    def dynamic_model_data_object(attributes={})
      @dynamic_model_data_object_attrs = attributes
    end

    def dynamic_model_attribute(attributes={})
      @dynamic_model_attribute_attrs = attributes
    end
  end
end

ActiveRecord::Base.extend DynamicModel::ActiveRecord
