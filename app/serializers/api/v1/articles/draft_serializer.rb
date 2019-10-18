# frozen_string_literal: true

class Api::V1::Articles::DraftSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :updated_at, :user_id
  belongs_to :user
end
