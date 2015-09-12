class RoomsController < InheritsController

  private
  def get_collection
    if params[:forum_id]
      @collection = Room.where(:forum_id => params[:forum_id])
    else
      @collection = Room.all
    end
  end

  def room_params
    params.require(:room).permit(:id, :forum_id, :name, :number, :events_attributes => [:id, :name, :begin_date, :end_date, :event_type_id, :room_id, :_destroy])
    #params.require(:contact).permit(:name, :contact_data_id, :socnet_links_id, :organization_id, :skills_id, :workpost_id, :industries_id, :equips_id, :intellect_properties_id, :team_projects_id, :chief_projects_id, :expert_projects_id, :member_events_id, :project_tasks_id)
  end
end