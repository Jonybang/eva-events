class PersonsController < InheritsController

  def create
    person_params[:password] = 123 unless person_params[:password]
    create!
  end

  private

  def person_params
    params.require(:person).permit!
    #params.require(:contact).permit(:name, :contact_data_id, :socnet_links_id, :organization_id, :skills_id, :workpost_id, :industries_id, :equips_id, :intellect_properties_id, :team_projects_id, :chief_projects_id, :expert_projects_id, :member_events_id, :project_tasks_id)
  end
end