class Forum::InForumController < InheritsController
  before_action :forum, :get_collection, :user_id
  helper_method :forum

  private
  def forum
    @forum ||= Forum.find params[:forum_id]
  end
  def user_id
    @user_id ||= session[:user_id]
  end
  def cur_person
    @cur_person ||= Person.where(id: user_id)
  end
  def cur_person_role
    if @cur_person
      @cur_person_role ||= @cur_person.role_in_forum forum
      session[:user_role] ||= @cur_person_role
    else
      session[:user_role] ||= 'visitor'
    end
  end
end