require "rails_helper"

RSpec.describe User, type: :model do
  describe "正常系" do
    context "アカウントとメールアドレスが入力されている時" do
      let(:user) { build(:user) }
      it "ユーザー登録ができる" do
        expect(user).to be_valid
      end
    end
  end
  describe "異常系" do
    context "アカウントとメールアドレスが入力されていない時" do
      let(:user) { build(:user, account: nil, email: nil) }
      it "ユーザー登録出来ない" do
        expect(user.valid?).to be false
      end
    end
  end
end