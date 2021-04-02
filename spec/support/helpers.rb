def new_data_attribute
  ::DataAttribute.new
end

def create_data_type
  DataType.create
end

def create_simpel_data_model
  data_type = create_data_type
  data_attribute = data_type.data_attributes.create(
    attribute_type: "Text",
    name: "title",
    validation_definition: {}
  )

  [data_type, data_attribute]
end
