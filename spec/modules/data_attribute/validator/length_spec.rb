RSpec.describe DynamicModel::DataAttribute::Validator::Length do
  describe "#validate" do
    before(:each) do
      @data_attribute = new_data_attribute
    end

    it "does not give a validation error if the condition is provided" do
      validator = described_class.new(
        {
          condition: {
            min: 5
          }
        },
        @data_attribute
      )

      expect(validator.validate).to eq true
    end

    it "does give a validation error if an invalid condition type is provided" do
      validator = described_class.new(
        {
          condition: "beer"
        }, @data_attribute
      )

      expect(validator.validate).to eq false
      expect(@data_attribute.errors.details[:validation_definition]).to include(
        {
          error: :invalid_condition,
          invalid_validation_key: "length",
          condition_error: :invalid_type
        }
      )
    end

    it "does give a validation error if an invalid value for min or max is provided" do
      validator = described_class.new(
        {
          condition: {
            min: { we_are: "Hashing!" }
          }
        }, @data_attribute
      )

      expect(validator.validate).to eq false
      expect(@data_attribute.errors.details[:validation_definition]).to include(
        {
          error: :invalid_condition,
          invalid_validation_key: "length",
          condition_error: :invalid_min
        }
      )
    end
  end
end
