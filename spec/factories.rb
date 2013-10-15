FactoryGirl.define do
  factory :user do
    email    "mn@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end