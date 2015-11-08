class Forum::EventsController < Forum::InForumController
  def index
    render 'events/index'
  end
  def create
    @collection << event
    render 'events/show'
  end

  def destroy
    event.destroy
    head(:ok)
  end

  private

  def event
    @resource ||= Event.find params[:id]
  end

  def get_collection
    @collection ||= forum.events
  end
end