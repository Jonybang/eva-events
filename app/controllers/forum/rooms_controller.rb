class Forum::RoomsController < Forum::InForumController
  before_action :def_params
  def index
    render 'rooms/index'
  end

  def create
    @collection << room
    render 'rooms/show'
  end

  def destroy
    room.destroy
    head(:ok)
  end

  private
  def room
    @resource ||= Room.find params[:id]
  end
  def get_collection
    @collection ||= forum.rooms
  end
  def def_params
    @near_event = params[:near_event]
    @cur_date = params[:cur_date]
  end
end