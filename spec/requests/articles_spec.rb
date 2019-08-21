require 'rails_helper'

RSpec.describe "Articles", type: :request do
  describe "GET /articles" do
    subject { get(articles_path) }
    before do
      create_list(:article,3)
    end

    it "記事一覧を全て取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["title", "body", "user_id"]
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /articles/:id" do
    subject { get(article_path(article_id)) }
    context "存在する記事の詳細を指定した時" do
      let(:article) { create(:article) }
      let(:article_id) { article.id }
      it "記事が表示される" do
        subject
        res = JSON.parse(response.body)
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["user_id"]).to eq article.user_id
        expect(response).to have_http_status(200)
      end
    end
    context "存在しない記事の詳細を指定した時" do
      let(:article_id) { 10000 }
      it "記事が表示されない" do
        expect {subject}.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
