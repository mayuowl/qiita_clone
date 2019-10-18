# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafs", type: :request do
  describe "GET /api/v1/articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    context "自分の下書きの記事がある時" do
      let(:headers) { authentication_headers_for(current_user) }
      let(:current_user) { create(:user) }
      let!(:article) { create(:article, :draft_status, user: current_user) }

      it "記事一覧を取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res[0]["title"]).to eq article.title
        expect(res[0]["body"]).to eq article.body
        expect(res[0]["user_id"]).to eq article.user_id
        expect(response).to have_http_status(200)
      end
    end
  end
  describe "GET /api/v1/articles/drafts/:id" do
    subject { get(api_v1_articles_draft_path(article_id), headers: headers) }

    context "自分の下書きの記事がある時" do
      let(:headers) { authentication_headers_for(current_user) }
      let(:current_user) { create(:user) }
      let!(:article) { create(:article, :draft_status, user: current_user) }
      let(:article_id) { article.id }

      it "記事詳細を取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["user_id"]).to eq article.user_id
        expect(response).to have_http_status(200)
      end
    end
  end
end
