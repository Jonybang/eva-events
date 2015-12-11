class TelegramUsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def command_execute
    Rails.logger.debug params
    head(200)
  end
  def root_post
    Rails.logger.debug params
    user_id = params[:message][:chat][:id]
    exist_user = TelegramUser.find_by chat_id: user_id

    TelegramUser.create(chat_id: user_id, forum_id: 2) unless exist_user

    head(200)
  end
end
