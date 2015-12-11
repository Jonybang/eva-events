class TelegramUsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def command_execute
    Rails.logger.debug params
  end
end
