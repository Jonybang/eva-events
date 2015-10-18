class Forum::RoomsController < ApplicationController
  respond_to :json

  helper_method :forum, :rooms_collection, :room

  def index
    respond_with :api, rooms_collection
  end
  def create
    rooms_collection << room

    forum.save
    respond_with room
  end

  def destroy
    rooms_collection.delete room

    forum.save
    respond_with room
  end

  private

  def forum
    @parent ||= Forum.find params[:forum_id]
  end

  def room
    @resource ||= Room.find params[:id]
  end

  def rooms_collection
    @collection ||= forum.rooms
  end
end