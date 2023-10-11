FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    user_type { User.user_types.keys.sample }
    sign_in_count { 0 }
    confirmed_at { Time.zone.now }

    trait :qa do
      user_type { :qa }
    end

    trait :manager do
      user_type { :manager }
    end

    trait :developer do
      user_type { :developer }
    end
  end
end
