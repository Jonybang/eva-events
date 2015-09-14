class Color < Base
  # name:string code:string

  has_many :events, class_name: 'Event'
  has_many :event_types, class_name: 'Event'
end