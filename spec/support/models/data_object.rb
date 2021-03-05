class DataObject < ActiveRecord::Base
  dynamic_model_data_object(data_column_name: "datas", data_type_class_name: "DataTypea")
  
  def self.hoi
    "doei"
  end
end
