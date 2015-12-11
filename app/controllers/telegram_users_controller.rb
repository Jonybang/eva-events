class TelegramUsersController < ApplicationController
  def command_execute
    Rails.logger.debug params
  end
end
