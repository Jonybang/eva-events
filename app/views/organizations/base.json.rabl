child :forums, :root => "forums", :object_root => false  do
    attributes :id, :name
    child :admins, :root => "admins", :object_root => false  do
        extends "inherits/base"
        attributes :id, :name
    end
    child :volunteers, :root => "volunteers", :object_root => false  do
        attributes :id, :name
    end
    child :posts, :root => "events", :object_root => false  do
        attributes :id, :name, :begin_date
    end
end