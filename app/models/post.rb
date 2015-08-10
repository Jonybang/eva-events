class Post < Base
  # name:string description:string active:boolean begin_date:datetime end_date:datetime

  belongs_to :forum, class_name: 'Forum'
  belongs_to :posted_by, class_name: 'Person', inverse_of: :posts, foreign_key: 'person_id'
end