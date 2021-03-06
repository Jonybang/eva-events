class UsersController < InheritsController
  skip_before_action :is_auth, only: [:new, :create, :api_anonym_create]

  def new
    @user = User.new
  end

  def create
    unless user_params[:email]
      flash.alert = 'Email не задан'
      render 'new'
      return
    end

    user_params[:email].downcase!

    existing_user = User.find_by_email user_params[:email]
    if existing_user
      flash.alert = 'Пользователь с таким email уже существует'
      render 'new'
      return
    end

    if user_params[:password] != user_params[:password_confirmation]
      flash.alert = 'Пароли не совпадают'
      render 'new'
      return
    end

    @user = Person.new(email: user_params[:email], password: user_params[:password])
    if @user.save!
      organization = Organization.new(name: user_params[:organization])
      @user.creator_organizations << organization
      @user.organizations << organization

      session[:user_id] = @user.id
      redirect_to manager_path, :notice => 'Добро пожаловать!'
    else
      flash.alert = 'Произошла ошибка сервера, вы не зарегистрированы :('
      render 'new'
    end
  end

  def api_anonym_create
    temp_password = KeePass::Password.generate('h{10}')

    @user = Person.new(anonym: true, password: temp_password)
    begin
      if @user.save!
        @user.email = @user.id.to_s + '@eva-events.ru'
        @user.name = '%09o' % @user.id
        @user.save

        session[:user_id] = @user.id

        respond_with(@user, :status => 200)
      else
        respond_with(@user = user, :status => 400)
      end
    rescue ActiveRecord::RecordInvalid => invalid
      puts invalid.record.errors
      Rails.logger.debug invalid.record.errors
    end
  end
  private

    def user_params
      params.require(:user).permit(:email, :organization, :password, :password_confirmation, :salt, :encrypted_password)
      #params.require(:user).permit(:email, :password_hash, :password_salt)
    end

end
