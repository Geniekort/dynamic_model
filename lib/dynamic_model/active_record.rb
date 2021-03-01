module DynamicModel
  module ActiveRecord
    def dynamic_model(attributes = {
      data_field_class_name: "DataField", data_object_class_name: "DataObject"
    })
      @dynamic_model_attrs = attributes
      include DynamicModel::DataType
    end

    def dynamic_model_data_object(attributes)
      @dynamic_model_data_object_attrs = attributes
    end
  end
end

ActiveRecord::Base.extend DynamicModel::ActiveRecord
