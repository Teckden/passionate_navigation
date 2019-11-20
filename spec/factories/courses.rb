FactoryBot.define do
  factory :course do
    sequence(:name) { |n| "Course #{n}" }
    state { 'active' }
    author { 'Harry' }
    category
  end
end
