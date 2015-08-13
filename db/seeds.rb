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
    [ 'jonybang@mail.ru', 'Jb192837', 'Паничев Евгений', 'Организация 1' ],
    [ 'ger2001a@mail.ru', '12345', 'Ледков Евгений', 'Бизнес инкубатор Ева' ],
    [ 'test@mail.ru', 'test', 'Тестовый Пользователь', 'Организация 2' ]
]

users_list.each do |email, pass, name, organization_name|
  user = Person.create(name: name, email: email, password: pass)
  organization = Organization.new(name: organization_name)
  user.creator_organizations << organization
  user.organizations << organization
end