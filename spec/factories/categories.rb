FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    state { 'active' }
    vertical

    trait :with_courses do
      after(:create) do |record|
        create_list(:course, 3, category: record)
      end
    end
  end
end
