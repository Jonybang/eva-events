class CreateEventsPersons < ActiveRecord::Migration
  def change
    create_table :events_admins, id: false do |t|
      t.belongs_to :person, index: true
      t.belongs_to :event, index: true
    end
    create_table :events_volunteers, id: false do |t|
      t.belongs_to :person, index: true
      t.belongs_to :event, index: true
    end
    create_table :events_members, id: false do |t|
      t.belongs_to :person, index: true
      t.belongs_to :event, index: true
    end
    create_table :events_visitors, id: false do |t|
      t.belongs_to :person, index: true
      t.belongs_to :event, index: true
    end
  end
end
