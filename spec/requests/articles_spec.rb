# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Articles", type: :request do
  describe "GET /articles" do
    subject { get(articles_path) }
    before do
      create_list(:article, 3)
    end

    it "記事一覧を全て取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res[0].keys).to eq %w[title body user_id]
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
      let(:article_id) { 10_000 }
      it "記事が表示されない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /articles" do
    subject { post(articles_path(params: params)) }
    let(:params) { { article: attributes_for(:article) } }
    # FIXME: devise_token_auth の導入が完了次第修正すること
    let(:current_user) { create(:user) }
    before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user) }

    it "記事が作成出来る" do
      expect { subject }.to change { Article.count }.by(1)
      expect(response).to have_http_status(204)
    end
  end

  describe "PATCH /articles/:id" do
    subject { patch(article_path(article.id, params: params)) }
    let(:params) { { article: { title: Faker::Book.title, body: Faker::TvShows::Friends.quote, created_at: Time.current } } }
    # FIXME: devise_token_auth の導入が完了次第修正すること
    let(:current_user) { create(:user) }
    before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user) }
    context "自分の記事を更新する時" do
      let!(:article) { create(:article, user: current_user) }

      it "自分の記事のタイトルと本文のみが正しく更新される" do
        expect { subject }.to change { Article.find(article.id).title }.from(article.title).to(params[:article][:title]) &
                              change { Article.find(article.id).body }.from(article.body).to(params[:article][:body]) &
                              not_change { Article.find(article.id).created_at }
        expect(response).to have_http_status(204)
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
    subject { delete(article_path(article.id)) }
    let(:current_user) { create(:user) }
    before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user) }

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
