class Forum::NewsController < ApplicationController
  respond_to :json

  helper_method :forum, :news_collection, :news

  def index
    respond_with :api, news_collection
  end
  def create
    news_collection << news

    forum.save
    respond_with news
  end

  def destroy
    news_collection.delete news

    forum.save
    respond_with news
  end

  private

  def forum
    @parent ||= Forum.find params[:forum_id]
  end

  def news
    @resource ||= News.find params[:id]
  end

  def news_collection
    @collection ||= forum.news
  end
end