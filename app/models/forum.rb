class Forum < Base
  # name:string alias:string description:string begin_date:datetime end_date:datetime
  has_many :events, class_name: 'Event'
end