module DynamicModel
  module ActiveRecord
    # By calling this method in an ActiveRecord model definition,
    #  this model will act as a DataType
    def dynamic_model(attributes = {})
      @dynamic_model_attrs = {
        data_attribute_class_name: "DataAttribute", data_object_class_name: "DataObject"
      }.merge(attributes)

      include DynamicModel::DataType
    end

    # By calling this method in an ActiveRecord model definition,
    #  this model will act as a DataAttribute
    def dynamic_model_attribute(attributes = {})
      @dynamic_model_attribute_attrs = attributes

      include DynamicModel::DataAttribute
    end

    # By calling this method in an ActiveRecord model definition,
    #  this model will act as a DataObject
    def dynamic_model_data_object(attributes = {})
      @dynamic_model_data_object_attrs = attributes

      include DynamicModel::DataObject
    end
  end
end

ActiveRecord::Base.extend DynamicModel::ActiveRecord
