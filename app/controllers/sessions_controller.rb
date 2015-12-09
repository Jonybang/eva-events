class SessionsController < InheritsController
  skip_before_action :is_auth

  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      cookies[:user_id] = user.id
      redirect_to manager_path, :notice => 'Logged in!'
    else
      flash.alert = 'Неправильный логин или пароль'
      render 'new'
    end
  end

  def api_create
    @user = nil
    if is_number?(params[:id])
      db_user = User.find_by(id: params[:id])
      @user = User.authenticate(db_user.email, params[:password])
    else
      @user = User.authenticate(params[:id], params[:password])
    end

    if @user
      session[:user_id] = @user.id
      cookies[:user_id] = @user.id
      respond_with(@user, :status => 200)
    else
      respond_with(@user, :status => 400)
    end
  end

  def api_destroy
    session[:user_id] = nil
    cookies[:user_id] = nil
    respond_with({}, :status => 200, :location => nil)
  end

  def current_user_id
    respond_with({id: session[:user_id]}, :status => 200, :location => nil)
  end


  def destroy
    session[:user_id] = nil
    cookies[:user_id] = nil
    redirect_to root_url, :notice => 'Logged out!'
  end
  def is_number?(string)
    true if Float(string) rescue false
  end
end
