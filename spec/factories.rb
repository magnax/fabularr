FactoryGirl.define do
  factory :user do
    email    "mn@example.com"
    password "foobar"
    password_confirmation "foobar"
  end

  factory :character do
  	name "Magnus"
  	gender "M"
  	location_id "1"
  	spawn_location_id "1"
  	user
  end

end