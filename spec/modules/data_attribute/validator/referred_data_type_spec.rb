RSpec.describe DynamicModel::DataAttribute::Validator::ReferredDataType do
  describe "#validate_value" do
    before(:each) do
      @referred_data_type = create_data_type
      @data_type, @data_attribute = create_simpel_data_model(data_attribute_type: "Reference")
      @validator_definition = {
        condition: {
          id: @referred_data_type.id
        }
      }
      @validator = described_class.new(@validator_definition, @data_attribute)

      @data_object = @data_type.data_objects.create(
        data: { @data_attribute.id.to_s => referred_object_id }
      )
    end

    let(:referred_object_id) { referred_object.id }
    let(:referred_object) { @referred_data_type.data_objects.create }

    it "validates if an id of a valid data object of the correct data_type is provided" do
      expect(@validator.validate_value(@data_object)).to eq true
      expect(@data_object.errors.none?).to eq true
    end

    context "with an invalid id provided" do
      let(:referred_object_id) { -1 }

      it "raises validation error" do
        expect(@validator.validate_value(@data_object)).to eq false
        expect(@data_object.errors.details[:data]).to include(
          {
            error: :invalid_attribute_value,
            error_detail: :referred_object_not_found,
            invalid_data_attribute_id: @data_attribute.id
          }
        )
      end
    end

    context "with an id of a data_object of a different data type provide" do
      let(:referred_object_id) { alternative_data_type.data_objects.create.id }
      let(:alternative_data_type) { create_data_type }

      it "raises validation error" do
        expect(@validator.validate_value(@data_object)).to eq false
        expect(@data_object.errors.details[:data]).to include(
          {
            error: :invalid_attribute_value,
            error_detail: :referred_object_not_found,
            invalid_data_attribute_id: @data_attribute.id
          }
        )
      end
    end
  end
end
