class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.string :name
      t.string :alias
      t.string :description
      t.datetime :begin_date
      t.datetime :end_date

      t.belongs_to :organization, index: true
      t.belongs_to :person, index: true

      t.timestamps null: false
    end
  end
end
