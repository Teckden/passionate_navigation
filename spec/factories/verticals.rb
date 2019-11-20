FactoryBot.define do
  factory :vertical do
    sequence(:name) { |n| "Vertical #{n}" }

    trait :with_categories do
      after(:create) do |record|
        create_list(:category, 3, vertical: record)
      end
    end
  end
end
