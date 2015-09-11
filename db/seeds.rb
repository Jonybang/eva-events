# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


event_types_list = [
    'Выступление',
    'Перерыв'
]

event_types_list.each do |name|
  EventType.create( name: name )
end

users_list = [
    [ 'test@mail.ru', 'test', 'Тестовый Пользователь', 'Организация 1' ],
    [ 'jonybang@mail.ru', 'Jb192837', 'Паничев Евгений', 'Организация 2' ],
    [ 'ger2001a@mail.ru', '12345', 'Ледков Евгений', 'Бизнес инкубатор Ева' ]
]

users_list.each do |email, pass, name, organization_name|
  user = Person.create(name: name, email: email, password: pass)
  organization = Organization.new(name: organization_name)
  user.creator_organizations << organization
  user.organizations << organization
end

forum = Forum.create(name: 'Мероприятие 1')
forum.admins << Person.first

Organization.first.forums << forum

rooms_list = [
    ['Помещение 1', [
        [ 'Событие 1', '2015-08-15 [8:00:00]', '2015-08-15 [10:00:00]' ],
        [ 'Событие 2', '2015-08-15 [10:00:00]', '2015-08-15 [11:00:00]' ],
        [ 'Событие 3', '2015-08-15 [14:00:00]', '2015-08-15 [17:00:00]' ]
    ]],
    ['Помещение 2', [
        [ 'Событие 4', '2015-08-15 [8:00:00]', '2015-08-15 [11:00:00]' ],
        [ 'Событие 5', '2015-08-15 [11:00:00]', '2015-08-15 [14:00:00]' ],
        [ 'Событие 6', '2015-08-15 [15:00:00]', '2015-08-15 [17:00:00]' ]
    ]]
]

rooms_list.each do |name, events_list|
  room = Room.create(name: name)
  forum.rooms << room
  events_list.each do |event_name, begin_date, end_date|
    event = Event.new(name: event_name, begin_date: begin_date, end_date: end_date, forum: forum)
    event.begin_date = (event.begin_date.to_time - 10*60*60).to_datetime
    event.end_date = (event.end_date.to_time - 10*60*60).to_datetime
    room.events << event
  end
end