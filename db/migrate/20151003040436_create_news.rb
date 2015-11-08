class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :name
      t.string :description
      t.boolean :completed
      t.boolean :published
      t.boolean :important

      t.boolean :for_visitor, default: true
      t.boolean :for_member, default: true
      t.boolean :for_volunteer, default: true
      t.boolean :for_admin, default: true

      t.datetime :published_time
      t.datetime :changed_time

      t.belongs_to :forum, index: true
      t.belongs_to :person, index: true

      t.references :newsable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end