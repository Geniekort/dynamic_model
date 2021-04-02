def new_data_attribute
  ::DataAttribute.new
end

def create_data_type
  DataType.create
end

def create_simpel_data_model(data_attribute_type: "Text")
  data_type = create_data_type
  data_attribute = data_type.data_attributes.create(
    attribute_type: data_attribute_type,
    name: "title",
    validation_definition: {}
  )

  [data_type, data_attribute]
end
