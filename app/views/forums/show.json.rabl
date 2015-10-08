object @resource

extends "inherits/base"

extends "forums/base"

child :admins, :root => "admins", :object_root => false  do
    attributes :id, :name, :email
end
child :volunteers, :root => "volunteers", :object_root => false  do
    attributes :id, :name, :email
end

child :events, :root => "events", :object_root => false  do
    attributes :id, :name, :begin_date, :end_date
    child :event_type  do
        attributes :id, :name
    end
end

child :rooms, :root => "rooms", :object_root => false  do
    extends "inherits/base"
    child :events, :root => "events", :object_root => false do
        attributes :id, :name
    end
end