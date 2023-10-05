FactoryBot.define do
  factory :userproject do
    user { FactoryBot.create(:user) }
    project { FactoryBot.create(:project) }
  end
end
