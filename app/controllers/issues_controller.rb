class IssuesController < InheritsController
  before_action :is_auth, only: []

  def new
    @issue = Issue.new
  end
  def create
    @issue = Issue.new(params[:issue].permit(:fullname, :email, :description))
    if verify_recaptcha(model: @issue) && @issue.save
      IssueMailer.support_email(@issue)
      redirect_to @issue
    else
      render 'new'
    end
  end
end