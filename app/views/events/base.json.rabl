attributes :begin_date, :end_date, :event_type_id
child :event_type  do
    attributes :id, :name
end