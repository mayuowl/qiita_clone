# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Articles", type: :request do
  describe "GET /articles" do
    subject { get(api_v1_articles_path) }

    context "公開済みの記事がある時" do
      let!(:article1) { create(:article, updated_at: 1.day.ago, status: "publish") }
      let!(:article2) { create(:article, updated_at: 2.days.ago, status: "publish") }
      let!(:article3) { create(:article, status: "publish") }

      it "一覧を全て取得できる(更新順)" do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq 3
        expect(res[0].keys).to eq %w[id title updated_at status user]
        expect(res.map { |d| d["id"] }).to eq [article3.id, article1.id, article2.id]
        expect(response).to have_http_status(200)
      end
    end

    context "下書きの記事がある時" do
      let!(:article) { create(:article, status: "draft") }

      it "記事一覧を取得できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "GET /articles/:id" do
    subject { get(api_v1_article_path(article_id)) }
    context "公開済みで、存在する記事の詳細を指定した時" do
      let(:article) { create(:article, status: "publish") }
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
      let(:article_id) { 10_000 }

      it "記事が表示されない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
    context "下書きの記事の詳細を指定した時" do
      let(:article) { create(:article, status: "draft") }
      let(:article_id) { article.id }

      it "記事が表示されない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:current_user) { create(:user) }
    let(:params) { { article: attributes_for(:article) } }
    let(:headers) { authentication_headers_for(current_user) }

    it "記事が作成出来る" do
      expect { subject }.to change { Article.count }.by(1)
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH /articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:current_user) { create(:user) }
    let(:params) { { article: attributes_for(:article) } }
    let(:headers) { authentication_headers_for(current_user) }

    context "自分の記事を更新する時" do
      let!(:article) { create(:article, user: current_user) }

      it "自分の記事のタイトルと本文のみが正しく更新される" do
        expect { subject }.to change { Article.find(article.id).title }.from(article.title).to(params[:article][:title]) &
                              change { Article.find(article.id).body }.from(article.body).to(params[:article][:body]) &
                              not_change { Article.find(article.id).created_at }
        expect(response).to have_http_status(200)
      end
    end
    context "他人の記事を更新する時" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "更新出来ない（見つからない）" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }.by(0)
      end
    end
  end

  describe "DELETE /articles/:id" do
    subject { delete(api_v1_article_path(article.id), headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { authentication_headers_for(current_user) }
    let(:article_id) { article.id }

    context "自分の記事を削除する時" do
      let!(:article) { create(:article, user: current_user) }

      it "任意の記事が削除出来ている" do
        expect { subject }.to change { Article.count }.by(-1)
        expect(response).to have_http_status(204)
      end
    end
    context "他人の記事を削除する時" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "削除出来ない（見つからない）" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }.by(0)
      end
    end
  end
end
