class Event < Post
  # name:string alias:string active:boolean description:string begin_date:datetime end_date:datetime

  belongs_to :event_type

  has_and_belongs_to_many :admins, class_name: 'Person', :join_table => 'events_admins'
  has_and_belongs_to_many :volunteers, class_name: 'Person', :join_table => 'events_volunteers'
  has_and_belongs_to_many :members, class_name: 'Person', :join_table => 'events_members'
  has_and_belongs_to_many :visitors, class_name: 'Person', :join_table => 'events_visitors'
end