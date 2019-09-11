# frozen_string_literal: true

class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :updated_at, :user_id
  belongs_to :user
end
