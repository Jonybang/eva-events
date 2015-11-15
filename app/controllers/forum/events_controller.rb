class Forum::EventsController < Forum::InForumController
  before_action :is_auth, only: [:person_subscribe, :person_unsubscribe]
  def show
    render 'events/show'
  end
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

  def person_subscribe
    exist_visitor = event.visitors.where(events_visitors: {person_id: user_id})
    unless exist_visitor.empty?
      return head(:not_acceptable)
    end
    event.visitors << cur_person
    head(:ok)
  end
  def person_unsubscribe
    event.visitors.delete cur_person
    head(:ok)
  end

  def subscribes
    @collection = event.visitors
    render 'persons/index'
  end

  private

  def event
    @resource ||= Event.find(params[:id] || params[:event_id])
  end

  def get_collection
    @collection ||= forum.events
  end
end