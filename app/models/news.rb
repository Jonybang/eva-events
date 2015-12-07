class News < Post
  # name:string description:string alias:string active:boolean description:string begin_date:datetime end_date:datetime

  belongs_to :newsable, polymorphic: true

  has_attached_file :image, :styles => { :medium => '900x900>', :thumb => '100x100>' }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  attr_accessor :delete_image
  before_validation { self.image.clear if self.delete_image == '1' }

  def image_url
    image.url(:medium)
  end

  def self.create_by_object(object, changes)
    if changes && changes.length != 0
      name = '', description = ''
      if object.class == Event
        name = "Данные события #{object.name} изменились!"
        description = 'Новые данные:'
        changes.each do |key, val|
          description += "\n#{I18n.t(key)}: #{object.humanize_field key}"
        end
      end
      news = News.new(name: name, description: description, newsable: object, changed_time: object.updated_at,
                      forum: object.forum, posted_by: object.forum.admins.first)
      news.publish
      news.save
      return
    end
  end

  def publish
    self.published = true
    self.published_time = DateTime.now
  end
end
