class AddTestToTelegramUsers < ActiveRecord::Migration
  def change
    add_column :telegram_users, :test, :boolean
  end
end
