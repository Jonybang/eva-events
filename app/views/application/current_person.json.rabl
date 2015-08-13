object @person
attributes :id, :name, :email, :created_at, :updated_at
child :organizations, :root => "organizations", :object_root => false  do
    attributes :id, :name
end