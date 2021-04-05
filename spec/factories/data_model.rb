FactoryBot.define do
  factory :data_attribute do
    sequence(:name) { |n| "attribute_#{n}" }
    validation_definition { {} }
    attribute_type { "Text" }
  end

  factory :data_type do

  end

  factory :data_object do
    
  end
end
