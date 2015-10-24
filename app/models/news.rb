class News < Post
  # name:string description:string alias:string active:boolean description:string begin_date:datetime end_date:datetime

  belongs_to :newsable, polymorphic: true
  def image
    '/upload/img/news.jpg'
  end
end
