RSpec.describe DynamicModel::DataAttribute::Validator::Presence do
  describe "#validate" do
    before(:each) do
      @data_attribute = new_data_attribute  
    end

    it "does not give a validation error if the condition is provided" do
      validator = described_class.new({
        condition: true
      }, "1", @data_attribute)
      
      expect(validator.validate).to eq true
    end

    it "gives a validation error if the condition is not provided" do
      validator = described_class.new({
        random_stuff: true
      },
      "-1", @data_attribute)

      expect(validator.validate).to eq false
      expect(@data_attribute.errors.details[:validation_definition]).to include(
        {
          error: :blank_condition,
          invalid_validation_key: "presence"
        }
      )
    end
      
  end
end
