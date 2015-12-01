class ForumsController < InheritsController

  private

  def get_resource
    if params[:alias] && !params[:id]
      forum = Forum.find_by alias: params[:alias]

      #return head(404) if !forum || forum.empty?

      params[:id] = forum.id
    end
    super
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
end