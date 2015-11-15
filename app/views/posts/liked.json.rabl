node :liked do |p|
    @user_id && !p.likes.where(person_id: @user_id).empty?
end