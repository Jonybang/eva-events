attributes :description, :person_id, :completed, :forum_id, :image
child :newsable, :root => "newsable", :object_root => false  do
    extends "inherits/base"
end