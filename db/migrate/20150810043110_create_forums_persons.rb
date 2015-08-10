class CreateForumsPersons < ActiveRecord::Migration
  def change
    create_table :forums_admins, id: false do |t|
      t.belongs_to :person, index: true
      t.belongs_to :forum, index: true
    end
    create_table :forums_volunteers, id: false do |t|
      t.belongs_to :person, index: true
      t.belongs_to :forum, index: true
    end
    create_table :forums_members, id: false do |t|
      t.belongs_to :person, index: true
      t.belongs_to :forum, index: true
    end
    create_table :forums_visitors, id: false do |t|
      t.belongs_to :person, index: true
      t.belongs_to :forum, index: true
    end
  end
end
