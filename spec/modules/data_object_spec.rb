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
        data_type = create_data_type()
        @data_object.data_type_id = data_type.id
        @data_object.save
        expect(@data_object).to be_valid
      end
      
    end
  end
end
