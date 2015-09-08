class Room < Base
  # name:string number:string

  has_many :events, class_name: 'Event'
  belongs_to :forum
end