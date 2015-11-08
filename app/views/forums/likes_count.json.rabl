node :likes_count do |p|
  if @forum
    p.likes.where(forum: @forum, likeable: p).count
  else
    p.likes.where(likeable: p).count
  end
end