class Post < Base
  # name, description, active, begin_date, end_date

  belongs_to :forum, class_name: 'Forum'
end