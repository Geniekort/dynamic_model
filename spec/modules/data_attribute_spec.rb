RSpec.describe DynamicModel::DataAttribute do
  describe "validations" do
    before(:each) do
      @data_attribute = DataAttribute.new(
        name: "test_attribute",
        attribute_type: "String",
        validation_definition: {}
      )
    end

    it "does not raise a validation error with valid attribute" do
      @data_attribute.save
      expect(@data_attribute).to be_valid
    end

    it "raises a validation error if the attribute_type does not correspond to existing attribute type module" do
      @data_attribute.attribute_type = "Stringsydingsy"
      @data_attribute.save

      expect(@data_attribute).not_to be_valid
      expect(@data_attribute.errors.details[:attribute_type]).to include({ error: :invalid })
    end

    it "raises a validation error if the name field is not present" do
      @data_attribute.name = nil
      @data_attribute.save

      expect(@data_attribute).not_to be_valid
      expect(@data_attribute.errors.details[:name]).to include({ error: :blank })
    end

    describe "validation_definition validations" do
      it "rejects validation_definition" do
        skip
      end
    end
  end
end
