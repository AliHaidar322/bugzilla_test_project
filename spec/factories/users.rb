FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    email { 'john.doe@example.com' }
    password { 'password123' }
    user_type { User.user_types.keys.sample }
    sign_in_count { 0 }
  end
end
