class AddFullNameToTelegramUsers < ActiveRecord::Migration
  def change
    add_column :telegram_users, :full_name, :string
  end
end
