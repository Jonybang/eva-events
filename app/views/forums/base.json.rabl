child :admins, :root => "admins", :object_root => false  do
    attributes :id, :name, :email
end
child :volunteers, :root => "volunteers", :object_root => false  do
    attributes :id, :name, :email
end
child :posts, :root => "events", :object_root => false  do
    attributes :id, :name, :begin_date, :end_date
    child :event_type  do
        attributes :id, :name
    end
end

attributes :admin_ids, :volunteer_ids