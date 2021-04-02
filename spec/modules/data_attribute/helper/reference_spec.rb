RSpec.describe DynamicModel::DataAttribute::Helper::Reference do
  describe "validations" do
    before(:each) do
      @data_attribute = DataAttribute.new(
        name: "test_attribute",
        attribute_type: "Reference",
        validation_definition: {}
      )
    end

    describe "referred_data_type validation" do
      it "does raise validation error if the condition is not provided" do
        @data_attribute.validation_definition["referred_data_type"] = nil

        @data_attribute.save
        expect(@data_attribute).not_to be_valid
        expect(@data_attribute.errors.details[:validation_definition]).to include(
          {
            invalid_validation_key: "referred_data_type",
            error: :blank
          }
        )
      end

      it "does raise validation error if the condition is not provided" do
        @data_attribute.validation_definition["referred_data_type"] = {
          random_stuff: true
        }

        @data_attribute.save
        expect(@data_attribute).not_to be_valid
        expect(@data_attribute.errors.details[:validation_definition]).to include(
          {
            invalid_validation_key: "referred_data_type",
            error: :blank_condition
          }
        )
      end

      it "does raise validation error if the condition is provided but incomplete" do
        @data_attribute.validation_definition["referred_data_type"] = {
          condition: { random_stuff: true }
        }

        @data_attribute.save
        expect(@data_attribute).not_to be_valid
        expect(@data_attribute.errors.details[:validation_definition]).to include(
          {
            invalid_validation_key: "referred_data_type",
            error: :invalid_condition,
            condition_error: :missing_referred_data_type_id
          }
        )
      end

      it "does raise validation error if the condition is provided but referring to non existent DataType" do
        @data_attribute.validation_definition["referred_data_type"] = {
          condition: { id: -1 }
        }

        @data_attribute.save
        expect(@data_attribute).not_to be_valid
        expect(@data_attribute.errors.details[:validation_definition]).to include(
          {
            invalid_validation_key: "referred_data_type",
            error: :invalid_condition,
            condition_error: :unknown_data_type
          }
        )
      end

      it "validate" do
        referred_data_type = create_data_type
        @data_attribute.validation_definition["referred_data_type"] = {
          condition: { id: referred_data_type.id }
        }

        @data_attribute.save
        expect(@data_attribute).to be_valid
      end
    end
  end
end
