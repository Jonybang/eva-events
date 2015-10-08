class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :description
      t.datetime :begin_date
      t.datetime :end_date
      t.boolean :completed

      t.belongs_to :forum, index: true
      t.belongs_to :person, index: true

      t.timestamps null: false
    end
    create_table :tasks_performers, id: false do |t|
      t.belongs_to :person, index: true
      t.belongs_to :task, index: true
    end
  end
end
