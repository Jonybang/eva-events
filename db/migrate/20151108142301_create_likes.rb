class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.belongs_to :person
      t.belongs_to :forum

      t.references :likeable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
