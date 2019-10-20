# frozen_string_literal: true

class Api::V1::ArticlesController < Api::V1::ApiController
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :set_article, only: %i[update destroy]

  def index
    articles = Article.published.order(updated_at: :desc)
    render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
  end

  def show
    article = Article.published.find(params[:id])
    render json: article, serializer: Api::V1::ArticleSerializer
  end

  def create
    article = current_user.articles.create!(article_params)
    render json: article
  end

  def update
    @article.update!(article_params)
    render json: @article
  end

  def destroy
    @article.destroy!
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :status)
  end

  def set_article
    @article = current_user.articles.find(params[:id])
  end
end
