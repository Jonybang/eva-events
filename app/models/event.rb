class Event < Post
  # name:string description:string alias:string active:boolean description:string begin_date:datetime end_date:datetime

  belongs_to :event_type
  belongs_to :room

  belongs_to :color

  has_many :news, as: :newsable

  has_and_belongs_to_many :admins, class_name: 'Person', :join_table => 'events_admins'
  has_and_belongs_to_many :volunteers, class_name: 'Person', :join_table => 'events_volunteers'
  has_and_belongs_to_many :members, class_name: 'Person', :join_table => 'events_members'
  has_and_belongs_to_many :visitors, class_name: 'Person', :join_table => 'events_visitors'

  alias_method :original_color, :color
  def color
    if self.event_type
      self.original_color ? self.original_color : self.event_type.color
    else
      self.original_color
    end
  end

  def duration
    '%g' % ('%.2f' % ((((self.end_date - self.begin_date) / 1.hour)*10).round/10.0))
  end
  def local_time(type)
    date = nil
    if type == 'begin'
      date = self.begin_date
    elsif type == 'end'
      date = self.end_date
    end
    date.in_time_zone(!self.forum.time_zone || self.forum.time_zone.empty? ? 'Vladivostok' : self.forum.time_zone).strftime('%R')
  end
  def humanize_field(field)
    if field == 'end_date'
      self.local_time('end')
    elsif field == 'begin_date'
      self.local_time('begin')
    elsif field == 'room_id'
      self.room.name
    end
  end
  def alias_url
    self.room.alias_url + '/' + (self.alias.blank? ? self.id.to_s : self.alias)
  end
  def time_to_begin
    self.begin_date - DateTime.now
  end
  def get_ad(type='basic')
    if type == 'basic'
      self.name + ' скоро начнется!' +
        ' Время начала: ' + self.local_time('begin') +
        ' Продолжительность: ' + self.duration + ' ч.' +
        ' Площадка: ' + self.room.full_name +
        ' Расписание мероприятия: http://evaevents.ru/robomech'
    elsif type == 'telegram'
      '``` ' + self.name + ' скоро начнется!```' +
        ' Время начала: *' + self.local_time('begin') + '*' +
        ' Продолжительность: *' + self.duration + ' ч.' + '*' +
        ' Площадка: *' + self.room.full_name + '*' +
        ' Расписание мероприятия: http://evaevents.ru/robomech'
    end
  end
  def is_now?
    self.begin_date < DateTime.now && self.end_date > DateTime.now
  end
end