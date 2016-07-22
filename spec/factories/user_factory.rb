
FactoryGirl.define do
  sequence :user_authentication_token do |n|
    "xxxx#{Time.zone.now.to_i}#{rand(1000)}#{n}xxxxxxxxxxxxx"
  end

  factory :user do
    email { generate(:random_email) }
    password "Secret08"
    password_confirmation { password }

    if User.attribute_method? :authentication_token
      authentication_token { generate(:user_authentication_token) }
    end
  end

  factory :disabled_user, parent: :user do
    disabled_at { Time.zone.now }
    disabled_comment { Faker::Company.catch_phrase }
  end
end
