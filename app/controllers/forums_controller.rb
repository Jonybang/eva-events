class ForumsController < InheritsController

  private

  def get_resource
    if params[:alias] && !params[:id]
      forum = Forum.find_by alias: params[:alias]

      #return head(404) if !forum || forum.empty?
      params[:id] = forum.id
    end
    super
    get_room_groups
  end

  def get_collection
    if params[:organization_id]
      @collection = Forum.where(:organization_id => params[:organization_id])
    else
      @collection = Forum.all
    end
  end

  def forum_params
    params.require(:forum).permit(:name, :organization_id, :alias, :admin_ids => [], :volunteer_ids => [])
  end

  def get_room_groups
    group_size = 1
    group_size = 1 if is_mobile_request?
    @room_groups = []
    group_index = 0
    i = 0
    @resource.rooms.each do |room|
      unless i < group_size
        i = 0
        group_index += 1
      end

      @room_groups[group_index] = [] unless @room_groups[group_index]
      @room_groups[group_index].push(room)

      i += 1
    end
    @room_groups
  end
end