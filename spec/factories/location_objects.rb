FactoryBot.define do
  factory :location_object do
    subject_id { 1 }
    subject_type { "MyString" }
    amount { 1.5 }
    unit { "MyString" }
    damage { 1.5 }
  end
end
