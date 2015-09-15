class ForumsController < InheritsController

  #before_action :get_id_by_alias, only: :show

  # def show
  #   if params[:alias]
  #     resource = Forum.where(:alias => params[:alias])
  #   else
  #     show!
  #   end
  # end

  private

  def get_resource
    if params[:alias]
      resource = Forum.find_by alias: params[:alias]
      params[:id] = resource.id
    end
    @resource = resource
  end
  # def get_id_by_alias
  #   if params[:alias]
  #     resource = Forum.find_by alias: params[:alias]
  #     params[:id] = resource.id
  #   end
  # end

  def get_collection
    if params[:organization_id]
      @collection = Forum.where(:organization_id => params[:organization_id])
    else
      @collection = Forum.all
    end
  end

  def forum_params
    params.require(:forum).permit(:name, :organization_id, :admin_ids => [], :volunteer_ids => [])
    #params.require(:contact).permit(:name, :contact_data_id, :socnet_links_id, :organization_id, :skills_id, :workpost_id, :industries_id, :equips_id, :intellect_properties_id, :team_projects_id, :chief_projects_id, :expert_projects_id, :member_events_id, :project_tasks_id)
  end
end