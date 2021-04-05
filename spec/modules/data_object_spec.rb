RSpec.describe DynamicModel::DataObject do
  describe "validations" do
    before(:each) do
      @data_object = DataObject.new(
        data: {},
        data_type_id: 1
      )
    end

    describe "data_type association" do
      it "raises an error if no matching data_type is found" do
        @data_object.data_type_id = nil
        @data_object.save
        expect(@data_object).not_to be_valid
        expect(@data_object.errors.details[:data_type]).to include({ error: :blank })
      end

      it "does not raise an error if a correct data_type is associated" do
        data_type = create_data_type
        @data_object.data_type_id = data_type.id
        @data_object.save
        expect(@data_object).to be_valid
      end
    end

    describe "data getters" do
      let(:data_type) { create(:data_type) }
      let(:data_object) { data_type.data_objects.create(data: { data_attribute.id.to_s => raw_data_value }) }
      let(:raw_data_value) { "TestValue" }

      context "with a Text data_attribute" do
        let(:data_attribute) { create(:data_attribute, data_type: data_type) }

        describe "#get_raw_data_by_attribute_id" do
          it "returns the raw value" do
            expect(data_object.get_raw_data_by_attribute_id(data_attribute.id.to_s)).to eq "TestValue"
          end
        end

        describe "#get_raw_data_by_attribute" do
          it "returns the raw value" do
            expect(data_object.get_raw_data_by_attribute(data_attribute)).to eq "TestValue"
          end
        end

        describe "#get_data_by_attribute" do
          it "returns the parsed value" do
            expect(data_object.get_data_by_attribute(data_attribute)).to eq "TestValue"
          end
        end
      end

      context "with a Number data_attribute" do
        let(:data_attribute) { create(:data_attribute, data_type: data_type, attribute_type: "Number") }
        let(:raw_data_value) { 123 }

        describe "#get_raw_data_by_attribute_id" do
          it "returns the raw value" do
            expect(data_object.get_raw_data_by_attribute_id(data_attribute.id.to_s)).to eq 123
          end
        end

        describe "#get_raw_data_by_attribute" do
          it "returns the raw value" do
            expect(data_object.get_raw_data_by_attribute(data_attribute)).to eq 123
          end
        end

        describe "#get_data_by_attribute" do
          it "returns the parsed value" do
            expect(data_object.get_data_by_attribute(data_attribute)).to eq 123
          end

          context "with a stringified value" do
            let(:raw_data_value) { "12.25" }

            it "returns the value as a number" do
              expect(data_object.get_data_by_attribute(data_attribute)).to eq 12.25
            end
          end
        end
      end

      context "with a Reference data_attribute" do
        let(:referred_data_type) { create(:data_type) }
        let(:referred_object) { create(:data_object, data_type: referred_data_type) }
        let(:data_attribute) do
          create(
            :data_attribute,
            data_type: data_type,
            attribute_type: "Reference",
            validation_definition: { referred_data_type: { condition: { id: referred_data_type.id } } }
          )
        end
        let(:raw_data_value) { referred_object.id }

        describe "#get_data_by_attribute" do
          it "returns the parsed object" do
            result = data_object.get_data_by_attribute(data_attribute)
            expect(result).to be_a DataObject
            expect(result.id).to eq referred_object.id
          end

          context "if the object does not exist (anymore)" do
            let(:referred_object) { double(id: 0) }

            it "returns nil" do
              result = data_object.get_data_by_attribute(data_attribute)
              expect(result).to eq nil
            end
          end

          context "if no value was stored at all" do
            let(:referred_object) { double(id: nil) }
            
            it "returns nil" do
              result = data_object.get_data_by_attribute(data_attribute)
              expect(result).to eq nil
            end
          end

        end
      end
    end
  end
end
