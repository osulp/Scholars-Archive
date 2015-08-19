FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }

    factory :joe do
      username 'joe'
    end
    trait :admin do
      group_list "admin"
    end
  end
end
