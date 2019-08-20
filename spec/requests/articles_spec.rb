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
end
