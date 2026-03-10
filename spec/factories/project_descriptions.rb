FactoryBot.define do
  factory :project_description do
    subject_id { 1 }
    subject_type { "MyString" }
    unit { "MyString" }
    amount { 1.5 }
  end
end
