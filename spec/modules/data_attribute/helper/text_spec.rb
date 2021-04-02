RSpec.describe DynamicModel::DataAttribute::Helper::Text do
  describe "validations" do
    before(:each) do
      @data_attribute = DataAttribute.new(
        name: "test_attribute",
        attribute_type: "Text",
        validation_definition: {}
      )
    end

    describe "presence validation" do
      it "does not give a validation error if the condition is provided" do
        @data_attribute.validation_definition["presence"] = {
          condition: true
        }

        @data_attribute.save
        expect(@data_attribute).to be_valid
      end

      it "gives a validation error if the condition is not provided" do
        @data_attribute.validation_definition["presence"] = {
          random_stuff: true
        }

        @data_attribute.save
        expect(@data_attribute).not_to be_valid
        expect(@data_attribute.errors.details[:validation_definition]).to include(
          {
            error: :blank_condition,
            invalid_validation_key: "presence"
          }
        )
      end
    end

    describe "length validation" do
      it "does not give a validation error if the condition is provided" do
        @data_attribute.validation_definition["length"] = {
          condition: { min: 5 }
        }

        @data_attribute.save
        expect(@data_attribute).to be_valid
      end

      it "gives a validation error if the condition is not provided" do
        @data_attribute.validation_definition["length"] = {
          random_stuff: true
        }

        @data_attribute.save
        expect(@data_attribute).not_to be_valid
        expect(@data_attribute.errors.details[:validation_definition]).to include(
          {
            error: :blank_condition,
            invalid_validation_key: "length"
          }
        )
      end
    end
  end
end
