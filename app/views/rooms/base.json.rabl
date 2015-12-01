attribute :forum_id, :number, :alias

if @near_event
    node :near_event do |u|
      u.near_event @cur_date
    end
end
extends "forums/likes_count"