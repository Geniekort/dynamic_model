RSpec.describe DynamicModel::DataAttribute::Validator::Length do
  describe "#validate" do
    it "does not give a validation error if the condition is provided" do
      validator = described_class.new(
        {
          condition: {
            min: 5
          }
        },
        "-1"
      )

      expect(validator.validate).to eq true
    end

    it "does give a validation error if an invalid condition type is provided" do
      validator = described_class.new({
        condition: "beer"
      },
      "-1")

      expect(validator.validate).to eq false
      expect(validator.errors.details[:validation_definition]).to include(
        {
          error: :invalid_condition,
          invalid_validation_key: "length",
          condition_error: :invalid_type
        }
      )
    end

    it "does give a validation error if an invalid value for min or max is provided" do
      validator = described_class.new({
        condition: {
          min: { we_are: "Hashing!" }
        }
      },
      "-1")

      expect(validator.validate).to eq false
      expect(validator.errors.details[:validation_definition]).to include(
        {
          error: :invalid_condition,
          invalid_validation_key: "length",
          condition_error: :invalid_min
        }
      )
    end
      
  end
end
