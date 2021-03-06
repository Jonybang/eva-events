require 'application_responder'

class ApplicationController < ActionController::Base
  include Mobylette::RespondToMobileRequests
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include ActionController::MimeResponds
  include ActionController::Helpers
  include ActionController::Cookies
  include ActionController::ImplicitRender
  respond_to :html


  protect_from_forgery with: :exception

  helper_method :current_user
  before_action :current_user


  # def index
  #   unless @current_user
  #     redirect_to '/login/'
  #   end
  # end

  def user_id
    render plain: @current_user.id
  end

  def current_person
    @person = Person.find @current_user.id
  end
  private

  def current_user
    if (!session || !session[:user_id])
      return
    end
    user_id = session[:user_id]
    @current_user ||= User.find_by(id: user_id) if user_id
  end
end
