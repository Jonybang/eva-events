class EventsController < InheritsController

  private

  def get_collection
    if params[:forum_id]
      @collection = Event.where(:forum_id => params[:forum_id])
    else
      @collection = Event.all
    end
  end

  def event_params
    params.require(:event).permit!
    #params.require(:contact).permit(:name, :contact_data_id, :socnet_links_id, :organization_id, :skills_id, :workpost_id, :industries_id, :equips_id, :intellect_properties_id, :team_projects_id, :chief_projects_id, :expert_projects_id, :member_events_id, :project_tasks_id)
  end
end