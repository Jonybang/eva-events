class Forum::PersonsController < ApplicationController
  respond_to :json

  helper_method :forum, :persons_collection, :person

  # POST /api/v1/things
  def index
    persons_collection
    respond_with :api, persons_collection
  end
  def create
    persons_collection << person

    forum.save
    respond_with :api, person
  end

  def destroy
    persons_collection.delete person

    forum.save
    respond_with :api, person
  end

  private

  # используем этот метод для получения базового ресурса
  def forum
    @parent ||= Forum.find params[:forum_id]
  end
  def persons_collection
    if params[:role] == 'admin'
      @collection ||= forum.admins
    elsif params[:role] == 'volunteer'
      @collection ||= forum.volunteers
    end
  end
  def person
    @resource ||= Person.find params[:id]
  end
end