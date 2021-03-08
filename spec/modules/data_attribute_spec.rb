RSpec.describe DynamicModel::DataAttribute do
  describe "validations" do
    it "does not raise a validation error with valid attribute" do
      data_attribute = DataAttribute.create(title: "test_attribute", attribute_type: "String")
      expect(data_attribute).to be_valid
    end

    it "raises a validation error if the attribute_type does not correspond to existing attribute type module" do
      data_attribute = DataAttribute.create(title: "test_attribute", attribute_type: "Stringsydingsy")
      expect(data_attribute).not_to be_valid
      expect(data_attribute.errors.details[:attribute_type]).to include({error: :invalid})
    end
  end
end
