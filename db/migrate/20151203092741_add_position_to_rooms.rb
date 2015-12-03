class AddPositionToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :position, :integer
  end
end
