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

class Article < ApplicationRecord
  belongs_to :user
  has_many :article_likes, dependent: :destroy
  has_many :comments, dependent: :destroy
end
