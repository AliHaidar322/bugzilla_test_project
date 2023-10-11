FactoryBot.define do
  factory :bug do
    sequence(:title) { |n| "#{Faker::Lorem.sentence} #{n}" }
    sequence(:description) { |n| "#{Faker::Lorem.sentence(word_count: 20)[0..99]} #{n}" }
    deadline { Time.zone.today + 10 }
    bug_type { %w[bug feature enhancement].sample }
    status { Bug.statuses.keys.sample }
    creator { FactoryBot.create(:user) }
    project { FactoryBot.create(:project) }
    transient do
      with_screenshot { false }
    end

    after(:build) do |bug, evaluator|
      if evaluator.with_screenshot
        bug.screenshot.attach(io: File.open('spec/factories/images/image.jpg'), filename: 'image.jpg',
                              content_type: 'image/jpeg')
      end
    end
  end
end
