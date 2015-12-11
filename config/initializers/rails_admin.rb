require 'i18n'
I18n.default_locale = :en
RailsAdmin.config do |config|
  config.authorize_with do
    redirect_to '/login' unless current_user && current_user.is_admin?
  end

  config.model 'News' do
    edit do
      field :name
      field :description, :text do
        required true
      end
      include_all_fields
    end
  end
  config.model 'TelegramUser' do
    list do
      fields :id, :full_name, :chat_id, :test, :created_at
      include_all_fields
    end
  end
end