class SessionsController < InheritsController
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to manager_path, :notice => 'Logged in!'
    else
      flash.alert = 'Неправильный логин или пароль'
      render 'new'
    end
  end

  def api_create
    @user = User.authenticate(params[:email], params[:password])
    if @user
      session[:user_id] = @user.id
      respond_with(@user, :status => :success)
    else
      respond_with(@user, :status => :failed)
    end
  end


  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => 'Logged out!'
  end
end
