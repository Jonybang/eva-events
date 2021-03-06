class Forum::PersonsController < Forum::InForumController
  def index
    render 'persons/index'
  end

  def create
    @collection << person
    head(:ok)
  end

  def destroy
    @collection.delete person
    head(:ok)
  end

  def subscribed_events
    @collection = person.visitor_events.where(forum_id: params[:forum_id])
    render 'events/index'
  end
  private

  def person
    @resource ||= Person.find(params[:id] || params[:person_id])
  end

  def get_collection
    if params[:role] == 'admin'
      @collection ||= forum.admins
    elsif params[:role] == 'volunteer'
      @collection ||= forum.volunteers
    elsif params[:role] == 'member'
      @collection ||= forum.members
    elsif params[:role] == 'visitor'
      @collection ||= forum.visitors
    elsif !params[:role]
      @collection ||= forum.admins + forum.volunteers + forum.members + forum.visitors
    end
  end
end