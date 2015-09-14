class EventType < Base
  # name:string

  has_many :events, class_name: 'Event'

  belongs_to :color
end