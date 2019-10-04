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

class Comment < ApplicationRecord
  validates :body, presence: true

  belongs_to :user
  belongs_to :article
end
