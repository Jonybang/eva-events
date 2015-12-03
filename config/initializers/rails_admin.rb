require 'i18n'
I18n.default_locale = :en
RailsAdmin.config do |config|
  config.authorize_with do
    redirect_to '/login' unless current_user && current_user.is_admin?
  end
end