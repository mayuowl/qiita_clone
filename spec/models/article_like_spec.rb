# frozen_string_literal: true

# == Schema Information
#
# Table name: article_likes
#
#  id         :bigint           not null, primary key
#  user_id    :bigint
#  article_id :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "rails_helper"

RSpec.describe ArticleLike, type: :model do
  context "user_id と article_id がある時" do
    it "いいねできる" do
      article = create(:article)
      article_like = ArticleLike.create(user_id: article.user_id, article_id: article.id)
      expect(article_like).to be_valid
    end
  end
  context "user_id と article_id がない時" do
    it "いいねできない" do
      article = create(:article)
      article_like = ArticleLike.create(user_id: nil, article_id: nil)
      expect(article_like.valid?).to be false
    end
  end
end
