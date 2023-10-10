FactoryBot.define do
  factory :bug do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence(word_count: 20)[0..99] }
    deadline { Time.zone.today + 10 }
    bug_type { %w[bug feature enhancement].sample }
    status { Bug.statuses.keys.sample }
    creator { FactoryBot.create(:user) }
    association :project, factory: :project
  end
end
