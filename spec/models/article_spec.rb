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

require "rails_helper"

RSpec.describe Article, type: :model do
  describe "正常系" do
    context "タイトルと本文が入力されている時" do
      it "登録出来る" do
        article = create(:article)
        expect(article).to be_valid
      end
    end
    context "下書き記事を作成する時" do
      it "作成できる" do
        article = create(:article, status: "draft")
        expect(article).to be_valid
      end
    end
    context "公開記事を作成する時" do
      it "作成できる" do
        article = create(:article, status: "publish")
        expect(article).to be_valid
      end
    end
  end
  describe "異常系" do
    context "タイトルが入力されていない時" do
      it "登録出来ない" do
        article = build(:article, title: nil)
        expect(article.valid?).to be false
      end
    end
    context "本文が入力されていない時" do
      it "登録出来ない" do
        article = build(:article, body: nil)
        expect(article.valid?).to be false
      end
    end
  end
end
