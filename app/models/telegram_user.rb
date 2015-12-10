class TelegramUser < ActiveRecord::Base
  belongs_to :forum
end
