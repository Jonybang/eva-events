class Forum::InForumController < InheritsController
  before_action :forum, :get_collection
  helper_method :forum

  private
  def forum
    @forum ||= Forum.find params[:forum_id]
  end
  def user_id
    @user_id ||= session[:user_id]
  end
  def cur_person
    @cur_person ||= Person.find user_id
  end
  def cur_person_role
    @cur_person_role ||= cur_person.role_in_forum forum
    session[:user_role] ||= @cur_person_role
  end
end