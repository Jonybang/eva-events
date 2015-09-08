class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :number

      t.belongs_to :forum, index: true
    end
  end
end
