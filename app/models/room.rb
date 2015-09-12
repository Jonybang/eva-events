class Room < Base
  # name:string number:string
  default_scope { includes(:events).order('posts.begin_date ASC') }

  has_many :events, class_name: 'Event'
  accepts_nested_attributes_for :events, allow_destroy: true
  belongs_to :forum
end