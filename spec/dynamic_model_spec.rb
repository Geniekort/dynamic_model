RSpec.describe DynamicModel do
  it "has a version number" do
    expect(DynamicModel::VERSION).not_to be nil
  end

  it "does something useful" do
    d = DataType.create(title: "woeiwoei")
    o = d.data_objects.create(datas: {test: "Hallo daar!"})
    puts o.datas
    puts o.get_data
    expect(DataType.title).to eq("doei")
  end
end
