FactoryBot.define do
  factory :user_project do
    user { FactoryBot.create { :user } }
    project { FactoryBot.create { :project } }
  end
end
