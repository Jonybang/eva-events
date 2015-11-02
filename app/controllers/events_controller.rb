class EventsController < InheritsController
  def update
    object = Event.find event_params[:id]
    object.assign_attributes(event_params)
    changes = object.changes

    update! { get_resource and News.create_by_object(@resource, changes) and render :show and return }
  end
  private

  def get_collection
    collection = InheritsController.instance_method(:get_collection).bind(self).call
    if params[:forum_id]
      @collection = collection.where(:forum_id => params[:forum_id])
    else
      @collection = collection
    end
  end

  def event_params
    params.require(:event).permit(:id, :name, :begin_date, :end_date, :event_type_id, :room_id, :forum_id, :color_id)
    #params.require(:contact).permit(:name, :contact_data_id, :socnet_links_id, :organization_id, :skills_id, :workpost_id, :industries_id, :equips_id, :intellect_properties_id, :team_projects_id, :chief_projects_id, :expert_projects_id, :member_events_id, :project_tasks_id)
  end
end