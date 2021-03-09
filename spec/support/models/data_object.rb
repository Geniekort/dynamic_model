class DataObject < ActiveRecord::Base
  dynamic_model_data_object(data_column_name: "data", data_type_class_name: "DataType")
  
  def self.hoi
    "doei"
  end
end
