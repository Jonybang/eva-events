class Forum::EventsController < ApplicationController
  respond_to :json

  helper_method :forum, :events_collection, :event

  def index
    respond_with :api, events_collection
  end
  def create
    events_collection << event

    forum.save
    respond_with event
  end

  def destroy
    events_collection.delete event

    forum.save
    respond_with event
  end

  private

  def forum
    @parent ||= Forum.find params[:forum_id]
  end

  def event
    @resource ||= Event.find params[:id]
  end

  def events_collection
    @collection ||= forum.events
  end
end