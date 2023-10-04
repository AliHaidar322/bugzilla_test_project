FactoryBot.define do
  factory :bug do
    title { Faker::Lorem.sentence }
    deadline { Time.zone.today + 10 }
    bug_type { %w[bug feature enhancement].sample }
    status { Bug.statuses.keys.sample }
    creator { FactoryBot.create(:user) }
    project { FactoryBot.create(:project) }
  end
end
