# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /api/v1/auth" do
    subject { post(api_v1_user_registration_path, params: params) }
    context "必要な情報が正しく送信された時" do
      let!(:user) { create(:user) }
      let(:params) { attributes_for(:user) }
      it "ユーザー登録できる" do
        expect { subject }.to change { User.count }.by(1)
        expect(response).to have_http_status(200)
      end
    end
    context "アカウント名が送信されない時" do
      let(:params) { attributes_for(:user).slice(:account) }
      it "ユーザー登録できない" do
        expect { subject }.to change { User.count }.by(0)
      end
    end
    context "メールアドレスが送信されない時" do
      let(:params) { attributes_for(:user).slice(:email) }
      it "ユーザー登録できない" do
        expect { subject }.to change { User.count }.by(0)
      end
    end
    context "パスワードが送信されない時" do
      let(:params) { attributes_for(:user).slice(:password) }
      it "ユーザー登録できない" do
        expect { subject }.to change { User.count }.by(0)
      end
    end
  end

  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }
    context "登録済みユーザーデータが正しく送信された時" do
      let!(:user) { create(:user) }
      let(:params) { { email: user.email, password: user.password } }
      it "ログインできる" do
        subject
        expect(response).to have_http_status(200)
        headers = response.headers
        expect(headers["access-token"]).to be_present
        expect(headers["client"]).to be_present
        expect(headers["uid"]).to be_present
      end
    end
    context "登録済みユーザーの誤ったパスワードが送信された時" do
      let!(:user) { create(:user) }
      let(:params) { { email: user.email, password: "password" } }
      it "ログインできない" do
        subject
        expect(response).to have_http_status(401)
        headers = response.headers
        expect(headers["access-token"]).to be_blank
        expect(headers["client"]).to be_blank
        expect(headers["uid"]).to be_blank
      end
    end
    context "登録のないユーザーデータが送信された時" do
      let!(:user) { create(:user) }
      let(:params) { { email: "email", password: user.password } }
      it "ログインできない" do
        subject
        expect(response).to have_http_status(401)
        headers = response.headers
        expect(headers["access-token"]).to be_blank
        expect(headers["client"]).to be_blank
        expect(headers["uid"]).to be_blank
      end
    end
  end
end
