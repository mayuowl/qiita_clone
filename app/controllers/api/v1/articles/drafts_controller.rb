class Api::V1::Articles::DraftsController < ApplicationController
  def index
    articles = Article.draft.order(updated_at: :desc)
    render json: articles
  end
  def show
    article = Article.draft.find(params[:id])
    render json: article
  end
end
