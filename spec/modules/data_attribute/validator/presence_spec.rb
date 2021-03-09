RSpec.describe DynamicModel::DataAttribute::Validator::Presence do
  describe "#validate" do
    it "does not give a validation error if the condition is provided" do
      validator = described_class.new({
        condition: true
      })
      
      expect(validator.validate).to eq true
    end

    it "gives a validation error if the condition is not provided" do
      validator = described_class.new({
        random_stuff: true
      })

      expect(validator.validate).to eq false
      expect(validator.errors.details[:validation_definition]).to include(
        {
          error: :blank_condition,
          invalid_validation_key: "presence"
        }
      )
    end
      
  end
end
