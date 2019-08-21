# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  provider               :string(255)      default("email"), not null
#  uid                    :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  allow_password_change  :boolean          default(FALSE)
#  remember_created_at    :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  account                :string(255)
#  email                  :string(255)
#  tokens                 :text(65535)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

FactoryBot.define do
  factory :user do
    sequence(:account) { |n| "#{n}_#{Faker::Internet.username}" }
    sequence(:email) { |n| "#{n}_#{Faker::Internet.email}" }
    password { Faker::Internet.password }
  end
end
