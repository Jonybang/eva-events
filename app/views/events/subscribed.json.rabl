node :subscribed do |p|
    @user_id && !p.visitors.where(events_visitors: {person_id: @user_id}).empty?
end