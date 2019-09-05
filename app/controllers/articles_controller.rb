# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :set_article, only: %i[update destroy]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def create
    @article = current_user.articles.create!(article_params)
  end

  def update
    @article.update!(article_params)
  end

  def destroy
    @article.destroy!
  end

  private

  def article_params
    params.require(:article).permit(:title, :body)
  end

  def set_article
    @article = current_user.articles.find(params[:id])
  end
end
