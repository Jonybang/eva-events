class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :name
      t.string :description
      t.datetime :begin_date
      t.datetime :end_date
      t.boolean :active

      t.belongs_to :forum, index: true
      t.belongs_to :person, index: true

      #Event
      t.string :alias
      t.belongs_to :event_type
      t.belongs_to :room
      t.belongs_to :color

      t.timestamps null: false
    end
  end
end
