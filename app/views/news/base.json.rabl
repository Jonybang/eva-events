attributes :description, :person_id, :completed, :forum_id, :image
child :newsable, :root => "newsable", :object_root => false  do
    extends "inherits/base"
end
child :posted_by, :root => "posted_by", :object_root => false  do
    attributes :id, :name, :image
end

extends "forums/likes_count"
extends "posts/liked"