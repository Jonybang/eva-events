class CreateTelegramUsers < ActiveRecord::Migration
  def change
    create_table :telegram_users do |t|
      t.string :chat_id
      t.belongs_to :forum, index: true

      t.timestamps null: false
    end
  end
end
