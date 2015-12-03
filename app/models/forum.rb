class Forum < Base
  # name:string alias:string description:string begin_date:datetime end_date:datetime

  belongs_to :organization, class_name: 'Organization'
  belongs_to :creator, class_name: 'Person', foreign_key: 'person_id'

  has_many :events, class_name: 'Event'
  has_many :news, class_name: 'News'
  has_many :tasks, class_name: 'Task'

  has_many :rooms, class_name: 'Room'

  has_and_belongs_to_many :admins, class_name: 'Person', :join_table => 'forums_admins'
  has_and_belongs_to_many :volunteers, class_name: 'Person', :join_table => 'forums_volunteers'
  has_and_belongs_to_many :members, class_name: 'Person', :join_table => 'forums_members'
  has_and_belongs_to_many :visitors, class_name: 'Person', :join_table => 'forums_visitors'
  def alias_url
    '/' + self.alias
  end
  def begin_date
    events.order(begin_date: :asc).first.begin_date
  end
  def end_date
    events.order(end_date: :desc).first.end_date
  end
  def local_time(type)
    date = nil
    if type == 'begin'
      date = self.begin_date
    elsif type == 'end'
      date = self.end_date
    end
    date.in_time_zone(self.forum.time_zone.empty? ? 'Vladivostok' : self.forum.time_zone)
  end
  def hours_array
    @hours = []
    temp_date = self.begin_date
    while temp_date < self.end_date do
      @hours.push(temp_date)
      if temp_date.min > 0
        temp_date += (60.minute - temp_date.min.minute)
      else
        temp_date += 1.hour
      end
    end
    @hours
  end
end