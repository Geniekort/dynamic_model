RSpec.describe DynamicModel::DataObject do
  describe "basic validations" do
    before(:each) do
      @data_type, @data_attribute = create_simpel_data_model
      @data_object = @data_type.data_objects.new
    end

    context "without any data validation rules" do
      it "is valid with no data" do
        expect(@data_object).to be_valid
      end

      it "is valid with valid data" do
        @data_object.data = {
          @data_attribute.id.to_s => "Hi there, a test title"
        }

        expect(@data_object).to be_valid
      end

      it "raises a validation error when invalid attribute id is used as key for data" do
        @data_object.data = {
          "-1" => "Hi there, a test title for a non-existent attribute"
        }

        expect(@data_object).not_to be_valid
        expect(@data_object.errors.details[:data]).to include(
          { error: :invalid_attribute_ids, invalid_attribute_ids: ["-1"] }
        )
      end
    end

    context "with presence validation enabled" do
      before(:each) do
        @data_attribute.update(
          validation_definition: {
            presence: { condition: true }
          }
        )
      end

      it "saves with valid input string" do
        @data_object.data = {
          @data_attribute.id.to_s => "Hi there, a test title"
        }

        expect(@data_object).to be_valid
      end

      it "raises a validation error when an empty title is provided" do
        @data_object.data = {
          @data_attribute.id.to_s => ""
        }

        expect(@data_object).not_to be_valid
        expect(@data_object.errors.details[:data]).to include(
          { 
            error: :invalid_attribute_value, 
            invalid_attribute_id: @data_attribute.id.to_s,
            value_error: :blank
          }
        )
      end

      it "raises a validation error when a number title is provided" do
        @data_object.data = {
          @data_attribute.id.to_s => 123
        }

        expect(@data_object).not_to be_valid
        expect(@data_object.errors.details[:data]).to include(
          { 
            error: :invalid_attribute_value,
            invalid_attribute_id: @data_attribute.id.to_s,
            value_error: :invalid_type
          }
        )
      end
    end
  end
end
