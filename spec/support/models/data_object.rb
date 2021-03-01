class DataObject < ActiveRecord::Base
  dynamic_model_data_object(data_column_name: "datas")
  
  def self.hoi
    "doei"
  end
end
