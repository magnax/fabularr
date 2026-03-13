FactoryBot.define do
  factory :recipe_instruction do
    type { "" }
    subject_id { 1 }
    subject_type { "MyString" }
    amount { 1 }
    unit { "MyString" }
  end
end
