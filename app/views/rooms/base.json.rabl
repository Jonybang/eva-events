attribute :forum_id, :number

if @near_event
    node :near_event do |u|
      u.near_event @near_date
    end
end