FactoryBot.define do
  factory :project_type do
    key { 'MyString' }
    base_speed { 1 }
    fixed { false }
  end
end
