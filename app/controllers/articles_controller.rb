# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :authenticate_api_user!, only: [:create, :update, :destroy]
  before_action :set_article, only: %i[update destroy]

  def index
    articles = Article.all
    render json: articles
  end

  def show
    article = Article.find(params[:id])
    render json: article
  end

  def create
    article = current_api_user.articles.create!(article_params)
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
    params.require(:article).permit(:title, :body)
  end

  def set_article
    @article = current_api_user.articles.find(params[:id])
  end
end
