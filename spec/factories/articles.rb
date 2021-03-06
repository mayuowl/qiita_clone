# frozen_string_literal: true

# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  title      :string(255)
#  body       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#

FactoryBot.define do
  factory :article do
    title { Faker::Book.title }
    body { Faker::TvShows::Friends.quote }
    status { :draft }
    user

    trait :draft_status do
      status { :draft }
    end
    trait :published_status do
      status { :published }
    end
  end
end
