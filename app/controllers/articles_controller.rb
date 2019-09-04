# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  def index
    @articles = Article.all
  end

  def show; end

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

  def set_user
    @article = Article.find(params[:id])
  end
end
