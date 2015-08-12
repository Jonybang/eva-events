child :admins, :root => "admins", :object_root => false  do
    attributes :id, :name
end
child :volunteers, :root => "volunteers", :object_root => false  do
    attributes :id, :name
end
child :posts, :root => "events", :object_root => false  do
    attributes :id, :name, :begin_date, :end_date
    child :event_type  do
        attributes :id, :name
    end
end