FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :user do
    email
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end
end
