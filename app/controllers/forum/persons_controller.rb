class Forum::PersonsController < ApplicationController
  respond_to :json

  helper_method :forum, :persons_collection, :person

  def index
    respond_with :api, persons_collection
  end
  def create
    persons_collection << person

    forum.save
    respond_with person
  end

  def destroy
    persons_collection.delete person

    forum.save
    respond_with person
  end

  private

  def forum
    @parent ||= Forum.find params[:forum_id]
  end

  def person
    @resource ||= Person.find params[:id]
  end

  def persons_collection
    if params[:role] == 'admin'
      @collection ||= forum.admins
    elsif params[:role] == 'volunteer'
      @collection ||= forum.volunteers
    elsif !params[:role]
      @collection ||= forum.admins + forum.volunteers
    end
  end
end