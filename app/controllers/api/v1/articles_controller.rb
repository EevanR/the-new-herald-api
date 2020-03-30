class Api::V1::ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :article_not_found

  def index
    if params.include?(:free)
      articles = Article.where(free: true)
      render json: articles[0]
    else
      articles = Article.where(published: true)
      articles = articles.where(location: params[:location]) if params[:location]
      articles = articles.where(category: params[:category]) if params[:category]
      articles = articles.paginate(page: params[:page], per_page: 4)
      render json: articles, each_serializer: Articles::IndexSerializer, meta: meta_attributes(articles)
    end
  end

  def show
    article = Article.find(params[:id])
    if article.published?
      render json: article, serializer: Articles::ShowSerializer
    else
      article_not_found
    end
  end

end