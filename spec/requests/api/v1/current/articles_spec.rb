# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    context "マイページにアクセスした時" do
      let(:headers) { authentication_headers_for(current_user) }
      let(:current_user) { create(:user) }
      let!(:article1) { create(:article, :publish_status, user: current_user) }
      let!(:article2) { create(:article, :draft_status, user: current_user) }

      it "自分の記事一覧（公開のみ）を取得できる" do
        subject
        res = JSON.parse(response.body)
        aggregate_failures "testing response" do
          expect(res.length).to eq 1
          expect(res[0]["title"]).to eq article1.title
          expect(res[0]["user"]["id"]).to eq current_user.id
          expect(res[0]["user"]["account"]).to eq current_user.account
          expect(res[0]["user"]["email"]).to eq current_user.email
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end
