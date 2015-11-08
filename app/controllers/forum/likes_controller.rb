class Forum::LikesController < Forum::InForumController
  def index
    render 'likes/index'
  end

  def create
    exist_like = Like.where(person_id: user_id, likeable: parent)
    unless exist_like.empty?
      return head(406)
    end
    like = Like.create(forum_id: forum.id, person_id: user_id)
    parent.likes << like

    render 'likes/index'
  end

  def destroy
    Like.destroy params[:id]
    render 'likes/index'
  end

  private

  def parent
    if params[:event_id]
      @parent ||= Event.find params[:event_id]
    elsif params[:news_id]
      @parent ||= News.find params[:news_id]
    elsif params[:room_id]
      @parent ||= Room.find params[:room_id]
    elsif params[:person_id]
      @parent ||= Person.find params[:person_id]
    elsif params[:task_id]
      @parent ||= Task.find params[:task_id]
    end
  end
  def get_collection
    @collection ||= parent.likes
  end
end
