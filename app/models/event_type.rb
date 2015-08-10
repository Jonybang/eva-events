class EventType < Base
  # name:string

  has_many :events, class_name: 'Event'
end