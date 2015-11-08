class Forum::NewsController < Forum::InForumController
  def index
    render 'news/index'
  end

  def create
    @collection << news
    render 'news/show'
  end

  def destroy
    news.destroy
    head(:ok)
  end

  private
  def news
    @resource ||= News.find params[:id]
  end

  def get_collection
    @collection ||= forum.news.where('for_' + cur_person_role => true)
  end
end