FactoryBot.define do
  factory :user do
    sequence(:account) { |n| "#{n}_#{Faker::Internet.username}" }
    sequence(:email) { |n| "#{n}_#{Faker::Internet.email}" }
    password { Faker::Internet.password }
  end
end