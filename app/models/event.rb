class Event < Post
  # name:string description:string alias:string active:boolean description:string begin_date:datetime end_date:datetime

  belongs_to :event_type
  belongs_to :room

  belongs_to :color

  has_and_belongs_to_many :admins, class_name: 'Person', :join_table => 'events_admins'
  has_and_belongs_to_many :volunteers, class_name: 'Person', :join_table => 'events_volunteers'
  has_and_belongs_to_many :members, class_name: 'Person', :join_table => 'events_members'
  has_and_belongs_to_many :visitors, class_name: 'Person', :join_table => 'events_visitors'

  alias_method :original_color, :color
  def color
    self.original_color ? self.original_color : self.event_type.color
  end
  def duration
    ((self.end_date - self.begin_date) / 1.hour).round
  end
end