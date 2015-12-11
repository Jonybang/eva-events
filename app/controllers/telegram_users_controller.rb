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

    unless exist_user
      TelegramUser.create(chat_id: user_id, forum_id: 2)
      TelegramClient.send_message(user_id, 'Вы успешно подписаны на бота "Робомех 2015"! Совсем скоро вам начнут приходить уведомления о начале событий мероприятия.')
    end

    head(200)
  end
end
