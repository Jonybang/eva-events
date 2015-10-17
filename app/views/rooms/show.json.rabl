object @resource

extends "inherits/base"

extends "rooms/base"

child :events, :root => "events", :object_root => false  do
    attributes :id, :name, :begin_date, :end_date
    child :event_type  do
        attributes :id, :name
    end
end