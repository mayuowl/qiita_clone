# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  user_id    :bigint
#  article_id :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  body       :text(65535)
#

FactoryBot.define do
  factory :comment do
    body { Faker::TvShows::Friends.quote }
    article
    user
  end
end
