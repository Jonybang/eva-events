# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

colors_list = [
    [ 'Синий', '#428bca' ],
    [ 'Зеленый', '#5cb85c' ],
    [ 'Оранжевый', '#ec971f' ],
    [ 'Голубой', '#78c5e7' ],
    [ 'Серый', 'grey' ]
]

colors_list.each do |name, code|
  Color.create( name: name, code: code )
end

event_types_list = [
    [ 'Выступление', Color.first ],
    [ 'Перерыв', Color.last ]
]

event_types_list.each do |name, color|
  EventType.create( name: name, color: color )
end

users_list = [
    [ 'test@mail.ru', 'test', 'Тестовый Пользователь', 'Организация 1' ],
    [ 'jonybang@mail.ru', 'Jb192837', 'Паничев Евгений', 'Организация 2' ],
    [ 'ger2001a@mail.ru', '12345', 'Ледков Евгений', 'Бизнес инкубатор Ева' ]
]

users_list.each do |email, pass, name, organization_name|
  user = Person.create(name: name, email: email, password: pass)
  organization = Organization.create(name: organization_name)
  user.creator_organizations << organization
  user.organizations << organization
end

forum = Forum.create(name: 'Мероприятие 1', alias: 'forum_1')
forum.admins << Person.first

Organization.first.forums << forum

rooms_list = [
    ['Помещение 1', [
        [ 'Событие 1', '2015-08-15 [8:00:00]', '2015-08-15 [10:00:00]', EventType.first ],
        [ 'Событие 2', '2015-08-15 [10:00:00]', '2015-08-15 [11:00:00]', EventType.last ],
        [ 'Событие 3', '2015-08-15 [14:00:00]', '2015-08-15 [17:00:00]', EventType.first ]
    ]],
    ['Помещение 2', [
        [ 'Событие 4', '2015-08-15 [8:00:00]', '2015-08-15 [11:00:00]', EventType.first ],
        [ 'Событие 5', '2015-08-15 [11:00:00]', '2015-08-15 [14:00:00]', EventType.last ],
        [ 'Событие 6', '2015-08-15 [15:00:00]', '2015-08-15 [17:00:00]', EventType.first ]
    ]]
]

rooms_list.each do |name, events_list|
  room = Room.create(name: name)
  forum.rooms << room
  events_list.each do |event_name, begin_date, end_date, event_type|
    event = Event.create(name: event_name, begin_date: begin_date, end_date: end_date, forum: forum, event_type: event_type)
    event.begin_date = (event.begin_date.to_time - 10*60*60).to_datetime
    event.end_date = (event.end_date.to_time - 10*60*60).to_datetime
    room.events << event
  end
end

news_list = [
    [ 'У события "Событие 1" изменилось расписание! ', 'Время начала Событие 1 перенесено с 6:00 на 8:00. ' ],
    [ 'У события "Событие 2" изменилось расписание! ', 'Время начала Событие 2 перенесено с 7:00 на 8:00. ' ]
]
news_list.each do |name, description|
  news = News.create(name: name, description: description, posted_by: Person.first)
  forum.news << news
end