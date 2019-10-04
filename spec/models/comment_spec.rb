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

require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "正常系" do
    context "本文が入力されている時" do
      let(:comment) { build(:comment) }
      it "コメントを投稿出来る" do
        expect(comment).to be_valid
      end
    end
  end
  describe "異常系" do
    context "本文が入力されていない時" do
      let(:article) { build(:article) }
      let(:comment) { build(:comment, article_id: article.id, body: nil) }
      it "コメントを投稿出来ない" do
        expect(comment.valid?).to be false
      end
    end
  end
end
