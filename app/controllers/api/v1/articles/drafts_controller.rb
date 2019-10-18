# frozen_string_literal: true

class Api::V1::Articles::DraftsController < Api::V1::Articles::ApiController
  before_action :authenticate_user!, only: %i[index show]

  def index
    articles = Article.draft.order(updated_at: :desc)
    render json: articles
  end

  def show
    article = Article.draft.find(params[:id])
    render json: article
  end
end
