class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :name
      t.string :description
      t.boolean :completed
      t.boolean :published
      t.boolean :important

      t.datetime :published_time
      t.datetime :changed_time

      t.belongs_to :forum, index: true
      t.belongs_to :person, index: true

      t.references :newsable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end