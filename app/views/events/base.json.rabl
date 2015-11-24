attributes :begin_date, :end_date, :event_type_id, :room_id, :color_id, :description
child :event_type  do
    attributes :id, :name
end
child :room  do
    attributes :id, :name
end
glue :color do
  attributes :code => :color_code
end
extends "forums/likes_count"
extends "posts/liked"
extends "events/subscribed"