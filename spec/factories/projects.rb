FactoryBot.define do
  factory :project do
    name { Faker::Lorem.unique.words(number: 1, supplemental: true).join(' ') }
    description { Faker::Lorem.sentence(word_count: 15) [0..99] }
  end
end
