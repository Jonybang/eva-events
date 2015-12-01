class AddAliasToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :alias, :string
  end
end
