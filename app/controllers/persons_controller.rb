class PersonsController < InheritsController

  def create
    person_params[:password] = 123 unless person_params[:password]
    create!
  end

  private

  def get_collection
    if params[:exclude_forum_admins]
      @collection = Person.all - Person.joins(:admin_forums).where('forum_id = ?', params[:exclude_forum_admins])
    elsif params[:exclude_forum_volunteers]
      @collection = Person.all - Person.joins(:volunteer_forums).where('forum_id = ?', params[:exclude_forum_volunteers])
    else
      @collection = Person.all
    end
  end

  def person_params
    params.require(:person).permit!
    #params.require(:contact).permit(:name, :contact_data_id, :socnet_links_id, :organization_id, :skills_id, :workpost_id, :industries_id, :equips_id, :intellect_properties_id, :team_projects_id, :chief_projects_id, :expert_projects_id, :member_events_id, :project_tasks_id)
  end
end