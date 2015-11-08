class Task < Post
  # name:string description:string alias:string active:boolean description:string begin_date:datetime end_date:datetime
  #belongs_to :task_status
  has_many :likes, as: :likeable

  has_and_belongs_to_many :performers, class_name: 'Person'
end
